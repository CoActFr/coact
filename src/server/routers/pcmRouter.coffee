pcmRouter = express.Router()

pcmRouter.use (request, response, next) ->
  console.log '%s PCMRouter: %s', request.method, request.url
  next()

pcmRouter.get '/:token', (request, response) ->
  pcmTestModel.getOrCreateUserFromToken request.params.token, (error, user) ->
    if error
      console.log "error"
      return response.sendStatus(500)

    pcmTest = user.ownerDocument()

    console.log user.answers

    removeID = (mongooseObject) ->
      return _.omit mongooseObject.toObject(), ['_id', '__v']
    response.render 'pcm/test',
      name: pcmTest.name
      videos: _.map pcmTest.videos, removeID
      answers: _.map user.answers, removeID

pcmRouter.post '/:token', (request, response) ->
  pcmTestModel.getOrCreateUserFromToken request.params.token, (error, user) ->
    if error
      console.log "error"
      return response.sendStatus 500

    if user.answers.length > request.body.answerNumber
      user.answers[request.body.answerNumber].profile = request.body.answer.profile
      user.answers[request.body.answerNumber].justification = request.body.answer.justification
    else
      user.answers.push new pcmAnswerModel request.body.answer

    user.ownerDocument().save (error) ->
      if error
        console.log "Error while saving pcm answer " + request.body.answerNumber + " : " + error
        return response.sendStatus 500
      return response.sendStatus 200

module.exports = pcmRouter