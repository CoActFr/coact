surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()


surveyRouter.get '/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    if formations.length > 0
      response.render 'survey',
        formation: formations[0]
        token: request.params.token
    else
      response.status(404)
      .send 'Not found'

module.exports = surveyRouter
