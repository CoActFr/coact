surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()

###
POST
###

surveyRouter.post '/answer/:token/:pageNumber', (request, response) ->
  pageNumber = parseInt request.params.pageNumber, 10
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
      response.redirect '/survey/' + request.params.token + "?page=" + (pageNumber + 1)

###
GET
###

getCompletion = (pages, pageNumber) ->
  numberOfAnswers = 0
  numberOfQuestions = 0
  for page, index in pages
    numberOfQuestions += page.questions.length
    if index < pageNumber
      numberOfAnswers = numberOfQuestions

  completion = 0
  if numberOfQuestions > 0
    completion = Math.floor(100*numberOfAnswers/numberOfQuestions)
  return completion

surveyRouter.get '/:token', (request, response) ->
  pageNumber = request.query.page ? 0

  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      pageNumber = Math.min pageNumber, formations[0].pages.length

      if pageNumber == formations[0].pages.length
        response.render 'survey/survey',
          pageNumber: pageNumber
          numberOfPages: formations[0].pages.length
          token: request.params.token
          completion: 100
          endPage: true

      response.render 'survey/survey',
        endPage: false
        pageNumber: pageNumber
        numberOfPages: formations[0].pages.length
        completion: getCompletion formations[0].pages, pageNumber
        page: formations[0].pages[pageNumber]
        token: request.params.token
    else
      response.status(404)
      .send 'Not found'

module.exports = surveyRouter
