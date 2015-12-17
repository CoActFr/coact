adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.post '/newSurvey/:name', (request, response) ->
  template = new surveyTemplateModel
    pages: [ new pageModel
      questions: [ new basicQuestionModel
        label: ""
        allowMark: true
        allowComment: false
      ]
    ]

  template.save (err) ->
    if err
      console.log 'Error during creation of survey "' + request.params.name + '"'

    survey = new surveyModel
      name: request.params.name
      template: template._id
      users: []

    survey.save (err) ->
      if err
        console.log 'Error during creation of survey "' + request.params.name + '"'
      response.redirect '/admin/survey/' + request.params.name

adminRouter.post '/deleteSurvey/:name', (request, response) ->
  surveyModel.remove name: request.params.name, (error) ->
    if error
      return console.log 'Error : ' + error
    name: request.params.name
  response.redirect '/admin/allSurvey'



adminRouter.post '/updateSurvey/:name', (request, response) ->

  pages = request.body.pages

  surveyModel.findOne name: request.params.name
  .populate 'template'
  .exec (error, survey) ->
    if error
      console.log error
    if survey is null
      return console.log 'Error : survey "' + request.params.name + '" not Found'

    template = survey.template
    template.pages = []

    for page, pageNumber in pages
      template.pages[pageNumber] = new pageModel
        questions: []

      for question, questionNumber in page
        formatedQuestion = new basicQuestionModel
          label: question['\'label\'']
          allowMark: '\'allow-mark\'' of question
          allowComment: '\'allow-comment\'' of question

        template.pages[pageNumber]
        .questions[questionNumber] = formatedQuestion

    template.save (err)->
      if err
        console.log 'Error during creation of survey "' + request.params.name + '"'
      response.redirect '/admin/sendSurvey/' + request.params.name

adminRouter.get '/survey/:name', (request, response) ->
  surveyModel.findOne name: request.params.name
  .populate 'template'
  .exec (error, survey) ->
    if error
      console.log error
    unless survey is null
      console.log survey
      response.render 'admin/survey',
        newSurvey: false
        template: survey.template
        name: request.params.name
    else
      response.render 'admin/survey',
        newSurvey: true
        name: request.params.name

adminRouter.get '/sendSurvey/:name', (request, response) ->
  surveyModel.findOne name: request.params.name
  .exec (error, survey) ->
    if error
      console.log error
    unless survey is null
      console.log survey
      console.log _.map survey.users, 'email'
      response.render 'admin/sendSurvey',
        emails: _.map survey.users, 'email'
        name: request.params.name
    else
      response.redirect '/admin/survey/' + request.params.name

adminRouter.post '/sendSurvey/:name', (request, response) ->
  emails = request.body.emails
  unless emails
    emails = []

  toKeep = []
  surveyModel.findOne name: request.params.name
  .exec (error, survey) ->
    console.log survey.users
    for user in survey.users
      if user and user.email in emails
        toKeep.push user.email
      else
        console.log "remove user " + user.email
        user.remove()

    for email in _.difference emails, toKeep
      console.log "pushing " + email
      survey.users.push
        email: email
        answers: []

    survey.save (err)->
      if err
        console.log 'Error during creation of survey "' + request.params.name + '"'
      response.redirect '/admin/sendSurvey/' + request.params.name

adminRouter.get '/getAnswer/:name/:userNumber', (request, response) ->
  surveyModel.findOne name: request.params.name
  .exec (error, survey) ->
    unless survey.users.length > request.params.userNumber
      response.redirect '/admin/sendSurvey/' + request.params.name

    encodedToken = survey.users[request.params.userNumber].getEncodedToken()
    response.redirect '/survey/' + encodedToken


adminRouter.get '/allSurvey', (request, response) ->
  surveyModel.find (error, surveys) ->
    response.render 'admin/allSurvey',
      surveys: surveys


module.exports = adminRouter
