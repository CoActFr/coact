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

  # Dashboard

adminFormationRouter.get '/dashboard/:id', (request, response) ->
  formationModel.findById request.params.id
  .populate('postFormationSurvey.answer')
  .exec (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404
    ### postFormationStatus :
            0 -> non envoyé
            1 -> envoyé
            2 -> répondu ###

    postFormationStatus = 0
    if formation.postFormationSurvey
      postFormationStatus += 1
      if formation.postFormationSurvey.answer?.validated
        postFormationStatus += 1
    response.render 'admin/formation/dashboard',
      formation: formation
      postFormationStatus: postFormationStatus

  # Send post formation survey

adminFormationRouter.get '/sendPostFormation/:id', (request, response) ->
  formationModel.findById request.params.id
  .populate('postFormationSurvey')
  .exec (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404
    response.render 'admin/formation/sendpostform',
      formation: formation

adminFormationRouter.post '/sendPostFormation/:id', (request, response) ->
  formationModel.findById request.params.id
  .populate('postFormationSurvey')
  .exec (error, formation) ->
    if error
      response.sendStatus 500
    unless formation
      response.sendStatus 404

    sendMail 'mails/postformationsurvey.jade',
      to: formation.buyer.email, # REQUIRED. This can be a comma delimited string just like a normal email to field.
      subject: '[CoAct] Questionnaire de facturation', # REQUIRED.
      connexionCode: formation.id
      firstname: formation.buyer.firstname
    , (error) ->
      if error
        console.log(error);
        return response.sendStatus 500

      createSurvey = true

      if formation.postFormationSurvey
        createSurvey = false
        pfs = formation.postFormationSurvey
        pfs.options = request.body.options
      else
        pfs = new postFormationSurveyModel
          sent: true
          options:
            request.body.options

      pfs.save (error) ->
        if error
          console.log(error);
          return response.sendStatus 500

        if createSurvey
          formation.postFormationSurvey = pfs._id
          formation.save (error) ->
            if error
              console.log(error);
              return response.sendStatus 500

            return response.sendStatus 200

        return response.sendStatus 200



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
