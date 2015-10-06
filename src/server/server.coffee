console.log "démarrage du serveur web"
if process.env.COACT_PORT
  port = process.env.COACT_PORT
else
  port = "7777"

express = require '../node_modules/express/index.js'
server = express()
app = express.Router()
server.set 'view engine', 'jade'
server.set 'views', './views'

logs_activated = true

app.use (req, res, next) ->
  if logs_activated = true
    console.log '%s %s', req.method, req.url
  next()

process.on 'uncaughtException', (error) ->
  console.log error

# Routes

app.get '/', (request, response) ->
  response.render 'landing', request.params

app.get '/personnel', (request, response) ->
  response.render 'personnel', request.params

app.get '/organisation', (request, response) ->
  response.render 'organisation', request.params

app.get '/technologie', (request, response) ->
  response.render 'technologie', request.params

app.get '/contact', (request, response) ->
  response.render 'contact', request.params

# Assets

app.get '/%styles%/main.css', (request, response) ->
  response.sendFile 'main.css', root: './%styles%'

app.get '/%scripts%/vendor.js', (request, response) ->
  response.sendFile 'vendor.js', root: './%scripts%'

app.get '/%scripts%/app.js', (request, response) ->
  response.sendFile 'app.js', root: './%scripts%'

app.get '/img/:image', (request, response) ->
  response.sendFile request.params.image, root: './img'

app.get '/favicon.ico', (request, response) ->
  response.sendFile 'favicon.ico', root: '.'

app.get '/robots.txt', (request, response) ->
  response.sendFile 'robots.txt', root: '.'

server.use '', app
server.listen port
console.log "serveur ecoute sur le port " + port
