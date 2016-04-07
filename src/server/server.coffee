console.log "démarrage du serveur web"

# init
require('../node_modules/dotenv/lib/main.js').config
  path: '../.env'
  silent: true

default_ENV_VARS =
  IS_PROD: false
  ADMIN_PWD: 'admin'
  MAILER_USER: 'no-reply@coact.fr'
  MAILER_PWD: 'secret'

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


### deps ###
global['_'] = require '../node_modules/lodash/index.js'
server.locals.moment = require('../node_modules/moment/moment.js');

### ---- ###

# PDFDocument
global['PDFDocument'] = require 'pdfkit'

# Mailer

mailer = require 'express-mailer'
mailer.extend server,
  from: 'no-reply@coact.fr',
  host: 'auth.smtp.1and1.fr', # hostname
  secureConnection: true, # use SSL
  port: 465, # port for secure SMTP
  transportMethod: 'SMTP', # default is SMTP. Accepts anything that nodemailer accepts
  auth:
    user: MAILER_USER,
    pass: MAILER_PWD

global['sendMail'] = (template, locals, callback) ->
  server.mailer.send template, locals, callback

# BodyParser

bodyParser = require '../node_modules/body-parser/index.js'
server.use bodyParser.json()
server.use bodyParser.urlencoded
  extended: true

# BusBoy
global['busboy'] = require '../node_modules/connect-busboy/index.js'

# Excel
global['Excel'] = require '../node_modules/exceljs/excel.js'

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

# Database

require './models.js'

# Logs

process.on 'uncaughtException', (error) ->
  console.log error

#Auth

basicAuth = require '../node_modules/basic-auth-connect/index.js'
auth = basicAuth (user, password) ->
  user is 'admin' and password is ADMIN_PWD

#Routers

server.use '/pcm', require('./%routers%/pcmRouter.js')
server.use '/admin', auth, require('./%routers%/adminRouter.js')
server.use '', require('./%routers%/mainRouter.js')

#End

server.listen port
console.log "serveur ecoute sur le port " + port
