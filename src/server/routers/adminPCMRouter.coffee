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

adminPCMRouter.get '/send/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    response.render 'pcmAdmin/send',
      pcmTest: pcmTest


adminPCMRouter.post '/send/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    if error or pcmTest is null
      console.log "Error while sending pcm test " + request.body.name + " by email"
      return response.sendStatus(500)
    sendMail 'mails/pcmtest.jade',
      to: request.body.email, # REQUIRED. This can be a comma delimited string just like a normal email to field.
      subject: '[CoAct] Questionnaire de Process Communication', # REQUIRED.
      pcmTestCode: pcmTest.getEncodedToken request.body.email
    , (error) ->
      if error
        console.log(error);
        return response.sendStatus(500)
      response.sendStatus(200)

adminPCMRouter.get '/sendTest', (request, response) ->
  sendMail 'mails/pcmtest.jade',
    to: 'aubry.herve@coact.fr', # REQUIRED. This can be a comma delimited string just like a normal email to field.
    subject: 'Test Email', # REQUIRED.
    pcmTestCode: 'QWRhbSNhdWJyeS5oZXJ2ZUBjb2FjdC5mcg=='
  , (error) ->
    if error
      console.log(error);
      return response.sendStatus(500)
    response.send('Email Sent');

adminPCMRouter.post '/inport-test', busboy(), (request, response) ->
  request.busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
    unless _.endsWith filename, '.xlsx'
      console.log "ERROR : " + filename + " is not a .xlsx"
      return response.status(406).send 'Provide a .xlsx file'


    workbook = new Excel.Workbook()
    workbook.xlsx.read file
    .then ->
      worksheet = workbook.getWorksheet(1);
      console.log worksheet.getCell("B1").value
      return response.sendStatus(500)

  request.pipe request.busboy

module.exports = adminPCMRouter
