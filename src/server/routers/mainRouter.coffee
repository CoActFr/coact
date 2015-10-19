mainRouter = global['express'].Router()

# Assets

mainRouter.get '/%styles%/main.css', (request, response) ->
  response.sendFile 'main.css', root: './%styles%'

mainRouter.get '/%scripts%/vendor.js', (request, response) ->
  response.sendFile 'vendor.js', root: './%scripts%'

mainRouter.get '/%scripts%/app.js', (request, response) ->
  response.sendFile 'app.js', root: './%scripts%'

mainRouter.get '/img/:image', (request, response) ->
  response.sendFile request.params.image, root: './img'

mainRouter.get '/fonts/:font', (request, response) ->
  response.sendFile request.params.font, root: './fonts'

mainRouter.get '/favicon.ico', (request, response) ->
  response.sendFile 'favicon.ico', root: '.'

mainRouter.get '/sitemap.xml', (request, response) ->
  response.sendFile 'sitemap.xml', root: '.'

mainRouter.get '/robots.txt', (request, response) ->
  response.sendFile 'robots.txt', root: '.'

# Routes

pagesAccepted = [
  'personnel'
  'organisation'
  'technologie'
  'contact'
]

mainRouter.get '/', (request, response) ->
  response.render 'landing', analytics: global['isProd']

mainRouter.get '/:page', (request, response) ->
  if request.params.page in pagesAccepted
    response.render request.params.page, analytics: global['isProd']
  else
    response.status(404)
    .send 'Not found'

module.exports = mainRouter
