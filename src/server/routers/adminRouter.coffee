adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.get '/survey/:token', (request, response) ->
  formationModel.find token: request.params.token, (error, formations) ->
    response.render 'survey',
      formations: formations
      token: request.params.token

module.exports = adminRouter
