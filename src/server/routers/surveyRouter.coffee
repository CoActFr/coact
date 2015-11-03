surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()

surveyRouter.post '/answer/:token/:pageNumber', (request, response) ->
  questions = request.body.questions
  formationModel.find token: request.params.token, (error, formations) ->
    unless formations.length > 0
      return console.log 'Error : formation "' + request.params.token + '" not Found'
    formation = formations[0]
    for question, questionNumber in formation.pages[request.params.pageNumber].questions
      if '\'mark\'' of questions[questionNumber]
        question.mark.value = questions[questionNumber]['\'mark\'']
      if '\'comment\'' of questions[questionNumber]
        question.comment.text = questions[questionNumber]['\'comment\'']

    formation.save (err)->
      if err
        console.log 'Error during creation of formation "' + request.params.token + '"'
      response.redirect '/survey/' + request.params.token + "?page=" + (request.params.pageNumber + 1)

surveyRouter.get '/:token', (request, response) ->
  pageNumber = request.query.page ? 0

  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      pageNumber = Math.min pageNumber, formations[0].pages.length - 1

      response.render 'survey/survey',
        pageNumber: pageNumber
        numberOfPages: formations[0].pages.length
        page: formations[0].pages[pageNumber]
        token: request.params.token
    else
      response.status(404)
      .send 'Not found'

module.exports = surveyRouter
