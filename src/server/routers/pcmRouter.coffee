pcmRouter = express.Router()

pcmRouter.use (request, response, next) ->
  console.log '%s PCMRouter: %s', request.method, request.url
  next()

module.exports = pcmRouter
