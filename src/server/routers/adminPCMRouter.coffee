adminPCMRouter = express.Router()

adminPCMRouter.use (request, response, next) ->
  console.log '%s AdminPCMRouter: %s', request.method, request.url
  next()

adminPCMRouter.get '/all', (request, response) ->
  pcmTestModel.remove _id: "568e3217e18ae1261c889611", (error, pcmTests) ->
    pcmTestModel.find (error, pcmTests) ->
      response.render 'pcmAdmin/all',
        pcmTests: pcmTests

adminPCMRouter.get '/see/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    response.render 'pcmAdmin/see',
      pcmTest: pcmTest

adminPCMRouter.post '/add', (request, response) ->
  unless request.body.name
    console.log "Error while saving pcm test " + request.body.name
    return response.sendStatus(500)
  pcmTestModel.findOne name: request.body.name
  .exec (error, test) ->
    if error
      console.log "Error while saving pcm test " + request.body.name
      return response.sendStatus(500)
    unless test is null
      console.log "Error while saving pcm test " + request.body.name + " : already exist"
      return response.sendStatus(409)

    new pcmTestModel
      name: request.body.name
      users: []
      videos: request.body.videos
    .save (error) ->
      if error
        console.log "Error while saving pcm test " + request.body.name
        return response.sendStatus(500)
      return response.sendStatus(200)

module.exports = adminPCMRouter
