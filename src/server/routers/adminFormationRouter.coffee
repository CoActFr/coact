adminFormationRouter = express.Router()

adminFormationRouter.use (request, response, next) ->
  console.log '%s AdminFormationRouter: %s', request.method, request.url
  next()

  # ALL

adminFormationRouter.get '/', (request, response) ->
  response.redirect '/admin/formation/all'

adminFormationRouter.get '/all', (request, response) ->
  formationModel.find (error, formations) ->
    console.log formations
    response.render 'admin/formation/all',
      formations: formations

  # Add formation


adminFormationRouter.get '/addForm', (request, response) ->
  response.render 'admin/formation/addformation', {}


module.exports = adminFormationRouter
