adminPCMRouter = express.Router()

adminPCMRouter.use (request, response, next) ->
  console.log '%s AdminPCMRouter: %s', request.method, request.url
  next()

# ALL

adminPCMRouter.get '/all', (request, response) ->
  pcmTestModel.remove _id: "568e3217e18ae1261c889611", (error, pcmTests) ->
    pcmTestModel.find (error, pcmTests) ->
      response.render 'pcmAdmin/all',
        pcmTests: pcmTests


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

# SEND Email

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
      firstname: request.body.firstname
    , (error) ->
      if error
        console.log(error);
        return response.sendStatus(500)
      response.sendStatus(200)


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
        endDashFound = false

        worksheet = workbook.getWorksheet(1);
        worksheet.eachRow (row, rowNumber) ->
          if rowNumber < 2 or endDashFound
            return

          if row.getCell('A').value == "#"
            endDashFound = true
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

        console.log "-- email to send : --"
        console.log emailToSend
        console.log "---------------------"

        unless emailToSend.length > 0
          return response.status(406).send "no emails founds"

        _.forEach emailToSend, (user, index) ->
          sendMail 'mails/pcmtest.jade',
            to: user.email
            subject: '[CoAct] Questionnaire de Process Communication' # REQUIRED.
            pcmTestCode: pcmTest.getEncodedToken user
            firstname: user.firstname
          , (error) ->
            if error
              console.log(error);

            if index == emailToSend.length - 1
              response.render 'pcmAdmin/inportusers',
                users: emailToSend

  request.pipe request.busboy

# Destroy

adminPCMRouter.get '/destroy/:name', (request, response) ->
  response.render 'pcmAdmin/destroy',
    name: request.params.name

adminPCMRouter.post '/destroy/:name', (request, response) ->
  pcmTestModel.remove name: request.params.name
  .exec (error) ->
    if error
      console.log "Error while destroying pcm test " + request.body.name
      return response.sendStatus(500)
    response.redirect '/admin/pcm/all',

# See result

adminPCMRouter.get '/see/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    response.render 'pcmAdmin/see',
      pcmTest: pcmTest

adminPCMRouter.get '/export-results/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    if error or pcmTest is null
      console.log "Error while sending pcm test " + request.body.name + " results"
      return response.sendStatus(500)

    response.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    response.setHeader('Content-disposition', 'attachment; filename=' + pcmTest.name.replace(' ', '_') + '_results.xlsx');

    workbook = new Excel.Workbook()

    workbook.creator = "CoAct"
    workbook.lastModifiedBy = "CoAct"
    workbook.created = new Date Date.now()
    workbook.modified = new Date Date.now()

    for video, videoNbr in pcmTest.videos
      worksheet = workbook.addWorksheet("Video " + videoNbr);

      worksheet.columns = [
        { header: [video.question, "Prénom"], key: "firstname", width: 10 }
        { header: ["", "Nom"], key: "lastname", width: 10 }
        { header: ["", "Email"], key: "email", width: 32 }
        { header: ["", "Empathique"], key: "harmoniser", width: 12 }
        { header: ["", "Travaillomane"], key: "thinker", width: 12 }
        { header: ["", "Persévérant"], key: "believer", width: 12 }
        { header: ["", "Promoteur"], key: "doer", width: 12 }
        { header: ["", "Réveur"], key: "dreamer", width: 12 }
        { header: ["", "Rebelle"], key: "funster", width: 12 }
        { header: ["", "Justification"], key: "justification", width: 100 }
      ]

      for user in pcmTest.users
        if user.answers.length > videoNbr
          answer = user.answers[videoNbr]

          worksheet.addRow
            firstname: user.firstname
            lastname: user.lastname
            email: user.email
            harmoniser: if answer.profile.harmoniser then 1 else 0
            thinker: if answer.profile.thinker then 1 else 0
            believer: if answer.profile.believer then 1 else 0
            doer: if answer.profile.doer then 1 else 0
            dreamer: if answer.profile.dreamer then 1 else 0
            funster: if answer.profile.funster then 1 else 0
            justification: answer.justification

    workbook.xlsx.write response
    .then ->
      response.end()

# Example d'excel

adminPCMRouter.get '/inport-pcmtest-example.xlsx', (request, response) ->
  response.sendFile 'inport-pcmtest-example.xlsx', root: '.'

adminPCMRouter.get '/inport-users-example.xlsx', (request, response) ->
  response.sendFile 'inport-users-example.xlsx', root: '.'

module.exports = adminPCMRouter
