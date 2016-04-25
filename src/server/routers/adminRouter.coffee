adminRouter = express.Router()

adminRouter.use (request, response, next) ->
  console.log '%s AdminRouter: %s', request.method, request.url
  next()

adminRouter.use '/pcm', require('./adminPCMRouter.js')
adminRouter.use '/formation', require('./adminFormationRouter.js')

adminRouter.get '/', (request, response) ->
  response.render 'admin/index', {}

module.exports = adminRouter
