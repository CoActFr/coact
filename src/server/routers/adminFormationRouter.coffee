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

adminFormationRouter.post '/addForm', (request, response) ->
  new formationModel request.body.formation
  .save (error) ->
    if error
        console.log "Error while creating formation"
        return response.sendStatus 500
      return response.sendStatus 200

  # Edit formation

adminFormationRouter.get '/editForm/:id', (request, response) ->
  formationModel.findById request.params.id, (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404
    response.render 'admin/formation/addformation',
      formation: formation

adminFormationRouter.post '/editForm/:id', (request, response) ->
  formationModel.findByIdAndUpdate request.params.id, request.body.formation,  (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404
    return response.sendStatus(200)

  # Destroy formation
adminFormationRouter.post '/destroyForm/:id', (request, response) ->
  formationModel.findById request.params.id, (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404
    formation.remove (error, formation) ->
      if error
          console.log "Error while destroying formation"
          return response.sendStatus(500)
        return response.sendStatus(200)

module.exports = adminFormationRouter
