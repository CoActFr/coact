console.log "démarrage du serveur web"
isProd = false;
if process.env.IS_PROD
  isProd = true

if isProd then port = "5010" else "7777"

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

pagesAccepted = [
  'personnel'
  'organisation'
  'technologie'
  'contact'
]

app.get '/', (request, response) ->
  response.render 'landing', analytics: isProd

app.get '/:page', (request, response) ->
  if request.params.page in pagesAccepted
    response.render request.params.page, analytics: isProd
  else
    response.status(404)
    .send 'Not found'

# Assets

app.get '/%styles%/main.css', (request, response) ->
  response.sendFile 'main.css', root: './%styles%'

app.get '/%scripts%/vendor.js', (request, response) ->
  response.sendFile 'vendor.js', root: './%scripts%'

app.get '/%scripts%/app.js', (request, response) ->
  response.sendFile 'app.js', root: './%scripts%'

app.get '/img/:image', (request, response) ->
  response.sendFile request.params.image, root: './img'

app.get '/fonts/:font', (request, response) ->
  response.sendFile request.params.font, root: './fonts'

app.get '/favicon.ico', (request, response) ->
  response.sendFile 'favicon.ico', root: '.'

app.get '/sitemap.xml', (request, response) ->
  response.sendFile 'sitemap.xml', root: '.'

app.get '/robots.txt', (request, response) ->
  response.sendFile 'robots.txt', root: '.'

server.use '', app
server.listen port
console.log "serveur ecoute sur le port " + port
