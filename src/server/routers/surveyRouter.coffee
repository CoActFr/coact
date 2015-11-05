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

surveyRouter.get '/:token', (request, response) ->
  pageNumber = request.query.page ? 0

  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      pageNumber = Math.min pageNumber, formations[0].pages.length - 1

      numberOfAnswers = 0
      numberOfQuestions = 0
      for page, index in formations[0].pages
        console.log page.questions.length
        numberOfQuestions += page.questions.length
        if index < pageNumber
          numberOfAnswers = numberOfQuestions

      console.log  numberOfQuestions
      console.log numberOfAnswers

      completion = 0
      if numberOfQuestions > 0
        completion = Math.floor(100*numberOfAnswers/numberOfQuestions)

      response.render 'survey/survey',
        pageNumber: pageNumber
        numberOfPages: formations[0].pages.length
        completion: completion
        page: formations[0].pages[pageNumber]
        token: request.params.token
    else
      response.status(404)
      .send 'Not found'

module.exports = surveyRouter
