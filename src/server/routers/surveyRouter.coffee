surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()

surveyRouter.post '/answer/:token', (request, response) ->
  pageNumber = request.body.page
  questions = request.body.questions
  formationModel.find token: request.params.token, (error, formations) ->
    unless formations.length > 0
      return console.log 'Error : formation "' + request.params.token + '" not Found'
    formation = formations[0]
    for question, questionNumber in formation.pages[pageNumber].questions
      if '\'mark\'' of questions[questionNumber]
        question.mark.value = questions[questionNumber]['\'mark\'']
      if '\'comment\'' of questions[questionNumber]
        question.comment.text = questions[questionNumber]['\'comment\'']

    formation.save (err)->
      if err
        console.log 'Error during creation of formation "' + request.params.token + '"'
      response.redirect '/survey/' + request.params.token

surveyRouter.get '/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      response.render 'survey/survey',
        formation: formations[0]
        token: request.params.token
    else
      response.status(404)
      .send 'Not found'

module.exports = surveyRouter
