console.log "démarrage du serveur web"

# init

global['isProd'] = false;
if process.env.IS_PROD
  global['isProd'] = true

logs_activated = true

port = if global['isProd'] then "5010" else "7777"

global['express'] = require '../node_modules/express/index.js'
server = express()
server.set 'view engine', 'jade'
server.set 'views', './views'

# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
global['mongoose'].connect 'mongodb://localhost/coact'

db = global['mongoose'].connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', (callback) ->
  # yay!

  formationSchema = mongoose.Schema
    token: String

  global['formationModel'] = mongoose.model 'Formation', formationSchema

# Header

server.use (request, response, next) ->
  response.setHeader 'Access-Control-Allow-Origin', '*'
  response.setHeader 'Access-Control-Allow-Methods', 'POST, GET, OPTIONS'
  response.setHeader 'Access-Control-Allow-Headers', 'Authorization, Origin, Content-Type, content-type, X-Requested-With, Accept'
  response.setHeader 'Access-Control-Allow-Credentials', true

  if request.method == "OPTIONS"
  # End CORS preflight request.
    response.writeHead(204);
    response.end();
  else
  # Implement other HTTP methods.
    next()

# Logs

process.on 'uncaughtException', (error) ->
  console.log error

#Routers

server.use '/survey', require('./%routers%/surveyRouter.js')
server.use '', require('./%routers%/mainRouter.js')

#End

server.listen port
console.log "serveur ecoute sur le port " + port
