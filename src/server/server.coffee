console.log "démarrage du serveur web"

# init
require('../node_modules/dotenv/lib/main.js').config
  path: '../.env'
  silent: true

default_ENV_VARS =
  IS_PROD: false
  ADMIN_PWD: 'admin'

for varname of default_ENV_VARS
  value = if varname of process.env then process.env[varname] else default_ENV_VARS[varname]
  if typeof(value) is "string" and value.toLowerCase() == 'true'
    value = true
  global[varname] = value
  console.log varname + ': ' + global[varname]

logs_activated = true

port = if IS_PROD then "5010" else "7777"

global['express'] = require '../node_modules/express/index.js'
server = express()
server.set 'view engine', 'jade'
server.set 'views', './views'

# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
mongoose.connect 'mongodb://localhost/coact'

db = mongoose.connection
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

#Auth

basicAuth = require '../node_modules/basic-auth-connect/index.js'
auth = basicAuth (user, password) ->
  user is 'admin' and password is ADMIN_PWD

#Routers

server.use '/survey', auth, require('./%routers%/surveyRouter.js')
server.use '', require('./%routers%/mainRouter.js')

#End

server.listen port
console.log "serveur ecoute sur le port " + port
