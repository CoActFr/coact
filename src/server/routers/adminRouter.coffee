adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.post '/newSurvey/:token', (request, response) ->
  formation = new formationModel
    token: request.params.token
    validated: false
    pages: [ new pageModel
      questions: new questionModel
        label: ""
        mark:
          allow: true
          value: -1
        comment:
          allow: false
          text: ""
    ]

  formation.save (err)->
    if err
      console.log 'Error during creation of formation "' + request.params.token + '"'
    response.redirect '/admin/survey/' + request.params.token

adminRouter.post '/deleteSurvey/:token', (request, response) ->
  formationModel.remove token: request.params.token, (error) ->
    if error
      return console.log 'Error : ' + error
    token: request.params.token
  response.redirect '/admin/allSurvey'



adminRouter.post '/updateSurvey/:token', (request, response) ->
  pageNumber = request.body.page
  questions = request.body.questions
  formationModel.find token: request.params.token, (error, formations) ->
    unless formations.length > 0
      return console.log 'Error : formation "' + request.params.token + '" not Found'
    formation = formations[0]
    formation.pages[pageNumber].questions = []
    for question, questionNumber in questions
      formatedQuestion = new questionModel
        label: question['\'label\'']
        mark:
          allow: '\'allow-mark\'' of question
          value: question['\'mark\'']
        comment:
          allow: '\'allow-comment\'' of question
          text: question['\'comment\'']


      formation.pages[pageNumber]
      .questions[questionNumber] = formatedQuestion

    formation.save (err)->
      if err
        console.log 'Error during creation of formation "' + request.params.token + '"'
      response.redirect '/admin/survey/' + request.params.token

adminRouter.get '/survey/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      console.log formations[0]
      response.render 'admin/survey',
        newSurvey: false
        formation: formations[0]
        token: request.params.token
    else
      response.render 'admin/survey',
        newSurvey: true
        token: request.params.token

adminRouter.get '/allSurvey', (request, response) ->
  formationModel.find (error, formations) ->
    response.render 'admin/allSurvey',
      formations: formations


module.exports = adminRouter
