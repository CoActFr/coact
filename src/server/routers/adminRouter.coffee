adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.post '/newSurvey/:token', (request, response) ->
  formation = new formationModel
    token: request.params.token
    pages: [
      validated: false
      questions: {
        label: ""
        mark:
          allow: true
          value: -1
        comment:
          allow: false
          text: "false"
      } for [1..5]
    ]

  formation.save (err)->
    if err
      console.log 'Error during creation of formation "' + request.params.token + '"'
    response.redirect '/admin/survey/' + request.params.token


adminRouter.post '/updateSurvey/:token/:page', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    unless formations.length > 0
      return console.log 'Error : formation "' + request.params.token + '" not Found'
    formation = formations[0]

    for questionNumber in [0..4]
      formation.pages[request.params.page]
      .questions[questionNumber]
      .label = request.body.labels[questionNumber]

    console.log request.body
    formation.save (err)->
      if err
        console.log 'Error during creation of formation "' + request.params.token + '"'
      response.redirect '/admin/survey/' + request.params.token

adminRouter.get '/survey/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      console.log formations[0]
      response.render 'surveyAdmin',
        newSurvey: false
        formation: formations[0]
        token: request.params.token
    else
      response.render 'surveyAdmin',
        newSurvey: true
        token: request.params.token


module.exports = adminRouter
