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
      pcmTestCode: pcmTest.getEncodedToken
        email: request.body.email
        firstname: request.body.firstname
        lastname: request.body.lastname
    , (error) ->
      if error
        console.log(error);
        return response.sendStatus(500)
      response.sendStatus(200)

adminPCMRouter.get '/inport-pcmtest-example.xlsx', (request, response) ->
  response.sendFile 'inport-pcmtest-example.xlsx', root: '.'

adminPCMRouter.get '/inport-users-example.xlsx', (request, response) ->
  response.sendFile 'inport-users-example.xlsx', root: '.'

adminPCMRouter.post '/inport-test', busboy(), (request, response) ->
  request.busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
    unless _.endsWith filename, '.xlsx'
      console.log "ERROR : " + filename + " is not a .xlsx"
      return response.status(406).send 'Provide a .xlsx file'


    workbook = new Excel.Workbook()
    workbook.xlsx.read file
    .then ->
      worksheet = workbook.getWorksheet(1);
      testname = worksheet.getCell("B1").value

      pcmTestModel.findOne name: testname
      .exec (error, test) ->
        if error
          console.log "Error while saving pcm test " + request.body.name
          return response.sendStatus(500)
        unless test is null
          console.log "Error while saving pcm test " + request.body.name + " : already exist"
          return response.status(409).send testname + " : already exist"

        pcmTest = new pcmTestModel
          name: testname
          videos: []
          users: []

        worksheet.eachRow (row, rowNumber) ->
          unless rowNumber > 2
            return

          pcmTest.videos.push new pcmVideoModel
            embedCode: row.getCell('A').value
            question: row.getCell('B').value

        pcmTest.save (error) ->
          if error
            console.log "Error while saving pcm test " + request.body.name
            return response.sendStatus(500)
          return response.redirect '/admin/pcm/all'

  request.pipe request.busboy

adminPCMRouter.post '/send-to-multiple-users/:name', busboy(), (request, response) ->
  request.busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
    unless _.endsWith filename, '.xlsx'
      console.log "ERROR : " + filename + " is not a .xlsx"
      return response.status(406).send 'Provide a .xlsx file'

    pcmTestModel.findOne name: request.params.name
    .exec (error, pcmTest) ->
      if error or pcmTest is null
        console.log "Error while sending pcm test " + request.body.name + " by email"
        return response.sendStatus(500)

      workbook = new Excel.Workbook()
      workbook.xlsx.read file
      .then ->
        emailToSend = []
        errors = []

        worksheet = workbook.getWorksheet(1);
        worksheet.eachRow (row, rowNumber) ->
          unless rowNumber > 1
            return
          row.getCell('C').type = Excel.ValueType.String
          email = ""
          switch row.getCell('C').type
            when Excel.ValueType.String
              email = row.getCell('C').value
            when Excel.ValueType.Hyperlink
              email = row.getCell('C').value.text

          if email == ""
            return


          emailToSend.push
            email: email
            firstname: row.getCell('A').value
            lastname: row.getCell('B').value

        _.forEach emailToSend, (user, index) ->
          sendMail 'mails/pcmtest.jade',
            to: user.email
            subject: '[CoAct] Questionnaire de Process Communication' # REQUIRED.
            pcmTestCode: pcmTest.getEncodedToken user
          , (error) ->
            if error
              console.log(error);

            console.log index

            if index == emailToSend.length - 1
              response.render 'pcmAdmin/inportusers',
                users: emailToSend

  request.pipe request.busboy

module.exports = adminPCMRouter
