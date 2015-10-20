surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()


surveyRouter.get '/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    response.render 'survey',
      formations: formations
      token: request.params.token

module.exports = surveyRouter
