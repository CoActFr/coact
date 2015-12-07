adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.post '/newSurvey/:token', (request, response) ->
  template = new surveyTemplateModel
    pages: [ new pageModel
      questions: [ new basicQuestionModel
        label: ""
        allowMark: true
        allowComment: true
      ]
    ]

  template.save (err) ->
    if err
      console.log 'Error during creation of survey "' + request.params.token + '"'

    survey = new surveyModel
      token: request.params.token
      template: template._id
      users: []

    survey.save (err) ->
      if err
        console.log 'Error during creation of survey "' + request.params.token + '"'
      response.redirect '/admin/survey/' + request.params.token

adminRouter.post '/deleteSurvey/:token', (request, response) ->
  surveyModel.remove token: request.params.token, (error) ->
    if error
      return console.log 'Error : ' + error
    token: request.params.token
  response.redirect '/admin/allSurvey'



adminRouter.post '/updateSurvey/:token', (request, response) ->

  pages = request.body.pages

  surveyModel.findOne token: request.params.token
  .populate 'template'
  .exec (error, survey) ->
    if error
      console.log error
    if survey is null
      return console.log 'Error : survey "' + request.params.token + '" not Found'

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
        console.log 'Error during creation of survey "' + request.params.token + '"'
      response.redirect '/admin/survey/' + request.params.token

adminRouter.get '/survey/:token', (request, response) ->
  surveyModel.findOne token: request.params.token
  .populate 'template'
  .exec (error, survey) ->
    if error
      console.log error
    unless survey is null
      console.log survey
      response.render 'admin/survey',
        newSurvey: false
        template: survey.template
        token: request.params.token
    else
      response.render 'admin/survey',
        newSurvey: true
        token: request.params.token

adminRouter.get '/sendSurvey/:token', (request, response) ->
  surveyModel.findOne token: request.params.token
  .exec (error, survey) ->
    if error
      console.log error
    unless survey is null
      console.log survey
      response.render 'admin/sendSurvey',
        users: survey.users
        token: request.params.token
    else
      response.redirect '/admin/survey/' + request.params.token

adminRouter.get '/allSurvey', (request, response) ->
  surveyModel.find (error, surveys) ->
    response.render 'admin/allSurvey',
      surveys: surveys


module.exports = adminRouter
