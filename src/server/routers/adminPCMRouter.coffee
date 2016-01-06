adminPCMRouter = express.Router()

adminPCMRouter.use (request, response, next) ->
  console.log '%s AdminPCMRouter: %s', request.method, request.url
  next()

adminPCMRouter.get '/all', (request, response) ->
  pcmTestModel.find (error, pcmTests) ->
    response.render 'pcmAdmin/all',
      pcmTests: pcmTests

module.exports = adminPCMRouter
