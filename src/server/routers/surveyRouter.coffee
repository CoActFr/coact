surveyRouter = global['express'].Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()


surveyRouter.get '/:token', (request, response) ->
  global['formationModel'].find token: request.params.token, (error, formations) ->
    response.render 'survey',
      formations: formations

module.exports = surveyRouter
