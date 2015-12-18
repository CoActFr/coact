surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()

###
POST
###

surveyRouter.post '/:encodedToken', (request, response) ->
  console.log request.body
  return
  response.redirect '/admin/survey/' + request.params.encodedToken

surveyRouter.post '/test/:encodedToken', (request, response) ->

  surveyModel.findUserByEncodedToken request.params.encodedToken, (error, user)->
    surveyTemplateModel.findById user.ownerDocument().template, (error, template) ->
      console.log user

      user.answers = []
      answerToSave = []

      for page, pageNumber in template.pages
        for question, questionNumber in page.questions
          answer = new basicAnswerModel request.body[pageNumber][questionNumber].answer

          console.log "-- a --"
          console.log answer

          answerToSave.push answer
          user.answers.push new answerModel
            questionId: question._id
            answer: answer._id

      console.log "-------"
      answerLeft = answerToSave.length
      for answer in answerToSave
        answer.save (err)->
          if err
            return response.sendStatus(500)
          answerLeft -= 1
          console.log answerLeft
          if answerLeft == 0 # save the user when all answer are saved then respond
            user.ownerDocument().save (err) ->
              if err
                console.log 'Error during answer "' + request.params.encodedToken + '"'
                return response.sendStatus(500)
              console.log user.answers
              return response.sendStatus(200)

###
GET
###

surveyRouter.get '/:encodedToken', (request, response) ->
  surveyModel.findUserByEncodedToken request.params.encodedToken, (error, user)->

    surveyTemplateModel.findById user.ownerDocument().template, (error, template) ->

      console.log user
      pages = []

      for page, pageNumber in template.pages
        pages[pageNumber] = []
        for question, questionNumber in page.questions
          answer = _.find(user.answers, 'questionId', question._id)

          console.log "--- answer ---"
          console.log answer

          unless answer and answer.answer
            answer =
              mark: 0
              comment: ""
          else
            answer = _.omit answer.answer.toObject(), ['_id', '__v']

          pages[pageNumber][questionNumber] =
            question: _.omit question.toObject(), ['_id', '__v']
            answer: answer

      console.log "--- ------- ---"

      response.render 'survey/survey',
        encodedToken: request.params.encodedToken
        email: user.email
        pages: pages

module.exports = surveyRouter
