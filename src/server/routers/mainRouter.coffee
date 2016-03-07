mainRouter = express.Router()
mainRouter.use (request, response, next) ->
  console.log '%s MainRouter: %s', request.method, request.url
  next()

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
  'jobs'
  'actu'
]

mainRouter.get '/', (request, response) ->
  response.render 'main/landing', analytics: IS_PROD

mainRouter.get '/:page', (request, response) ->
  if request.params.page in pagesAccepted
    response.render 'main/' + request.params.page, analytics: IS_PROD
  else
    response.status(404)
    .send 'Not found'

mainRouter.post '/contact', (request, response) ->
  unless request.body.firstname and request.body.lastname and request.body.organisation and request.body.email
    return response.sendStatus 500

  fromString = request.body.firstname + ' ' + request.body.lastname
  fromString += ' <' + request.body.email + '>'

  sendMail
    template:'mails/contact'
    from: fromString
  ,
    to: "contact@coact.fr" # REQUIRED. This can be a comma delimited string just like a normal email to field.
    subject: '[CoAct] Contacter Nous'
    lastname: request.body.lastname
    firstname: request.body.firstname
    organisation: request.body.organisation
    fonction: request.body.fonction
    email: request.body.email
    phone: request.body.phone
    interests:
      collaborativeTraining: request.body.interests.collaborativeTraining
      seminar: request.body.interests.seminar
      openForum: request.body.interests.openForum
      learningOrganisation: request.body.interests.learningOrganisation
      technologies: request.body.interests.technologies
      others: request.body.interests.others
    details: request.body.details
  , (error) ->
    if error
      console.log(error);
      return response.sendStatus(500)
    response.sendStatus(200)

mainRouter.post '/jobs', (request, response) ->
  unless request.body.firstname and request.body.lastname and request.body.email
    return response.sendStatus 500

  fromString = request.body.firstname + ' ' + request.body.lastname
  fromString += ' <' + request.body.email + '>'

  sendMail
    template:'mails/jobs'
    from: fromString
  ,
    to: "contact@coact.fr" # REQUIRED. This can be a comma delimited string just like a normal email to field.
    subject: '[CoAct] Rejoignez-Nous'
    lastname: request.body.lastname
    firstname: request.body.firstname
    email: request.body.email
    phone: request.body.phone
    speach: request.body.speach
  , (error) ->
    if error
      console.log(error);
      return response.sendStatus(500)
    response.sendStatus(200)

module.exports = mainRouter
