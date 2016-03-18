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
    console.log pcmTest
    response.render 'pcmAdmin/see',
      pcmTest: pcmTest
      byUser: not (request.query.by == "video")

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
        { header: ["", "Rêveur"], key: "dreamer", width: 12 }
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

# Correct Result

adminPCMRouter.get '/correct/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    removeID = (mongooseObject) ->
      return _.omit mongooseObject.toObject(), ['_id', '__v']
    user = _.find pcmTest.users, 'email', request.query.email
    response.render 'pcmAdmin/correct',
      name: pcmTest.name
      videos: _.map pcmTest.videos, removeID
      user:
        lastname: user.lastname
        firstname: user.firstname
        answers: _.map user.answers, removeID
        email: user.email

adminPCMRouter.post '/update-generic/:name/:index', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    if error or pcmTest is null
      console.log error
      return response.sendStatus(500)
    pcmTest.videos[request.params.index].genericAnswer = request.body.genericAnswer
    pcmTest.save (error) ->
      if error
        console.log error
        return response.sendStatus(500)
      return response.sendStatus(200)


adminPCMRouter.post '/correct/:name', (request, response) ->
  pcmTestModel.findOne name: request.params.name
  .exec (error, pcmTest) ->
    user = _.find pcmTest.users, 'email', request.query.email

    doc = new PDFDocument
      margin: 0
    # Generate Document
    for correction, index in request.body
      #Boxes
      doc.rect 0, 0, 612, 100
      .fill '#ccc'

      doc.rect 0, 382, 612, 310
      .fill '#26ADE4'

      doc.rect 0, 692, 612, 100
      .fill '#000'

      # Logo
      doc.image 'img/CoAct.png', 0, 0, width: 150
      doc.moveDown()

      # Title
      doc.fontSize 18
      doc.fill '#000'
      doc.text "Correction du questionnaire : ", 200, 15,
        width: 300
        align: 'left'

      doc.text pcmTest.name, 200, 40,
        width: 300
        align: 'left'

      userName = user.email
      if user.firstname or user.lastname
        userName = _.trim user.firstname + " " + user.lastname

      doc.fontSize 14
      doc.text "réalisé par " + userName, 200, 65,
        width: 300
        align: 'left'

      # Question
      doc.fontSize 18
      doc.text pcmTest.videos[index].question, 10, 110,
        width: 410
        align: 'left'
        underline: true
      doc.moveDown()

      # Answer

      doc.fontSize 14
      user_profiles = []
      if user.answers[index].profile.harmoniser
        user_profiles.push "Empathique"
      if user.answers[index].profile.thinker
        user_profiles.push "Travaillomane"
      if user.answers[index].profile.believer
        user_profiles.push "Persévérant"
      if user.answers[index].profile.doer
        user_profiles.push "Promoteur"
      if user.answers[index].profile.dreamer
        user_profiles.push "Rêveur"
      if user.answers[index].profile.funster
        user_profiles.push "Rebelle"

      doc.text "Votre réponse : ", 10, 150,
        width: 400
        align: 'left'

      doc.text user_profiles.join(', '), 110, 150,
        width: 400
        align: 'left'
      doc.moveDown()

      doc.text user.answers[index].justification,
        width: 400
        align: 'justify'
      doc.moveDown()

      # Correction

      correct_profiles = []
      if correction.profile.harmoniser
        correct_profiles.push "Empathique"
      if correction.profile.thinker
        correct_profiles.push "Travaillomane"
      if correction.profile.believer
        correct_profiles.push "Persévérant"
      if correction.profile.doer
        correct_profiles.push "Promoteur"
      if correction.profile.dreamer
        correct_profiles.push "Rêveur"
      if correction.profile.funster
        correct_profiles.push "Rebelle"

      doc.text "Correction : " , 10, 392,
        width: 400
        align: 'left'

      doc.text correct_profiles.join(', '), 110, 392,
        width: 400
        align: 'left'
      doc.moveDown()

      doc.text correction.comment,
        width: 400
        align: 'justify'

      # Footer

      doc.fill '#fff'
      doc.text "CoAct", 20, 702,
        width: 100
        align: 'left'

      doc.fill '#26ADE4'
      doc.fontSize 12
      doc.text "www.coact.fr", 20, 719,
        width: 100
        align: 'left'
        link: 'http://www.coact.fr'
        underline: true


      doc.fill '#ccc'
      doc.text "c/o La Ruche,\n84 Quai de Jemmapes,\n75010 Paris", 20, 736,
        width: 150
        align: 'left'

      unless index == request.body.length - 1
        doc.addPage()


    # End Document
    doc.end()

    sendMail {
      template: 'mails/correct.jade'
      cc: "contact@coact.fr",
      attachments: [
        fileName: 'Correction_' + pcmTest.name + '.pdf'
        streamSource: doc
        contentType: 'application/pdf'
      ]
      },{
        to: user.email
        subject: '[CoAct] Questionnaire de Process Communication'
        user: user
        testname: pcmTest.name
      }
    , (error) ->
      if error
        console.log(error);

        return response.sendStatus(500)
      response.sendStatus(200)

# Example d'excel

adminPCMRouter.get '/inport-pcmtest-example.xlsx', (request, response) ->
  response.sendFile 'inport-pcmtest-example.xlsx', root: '.'

adminPCMRouter.get '/inport-users-example.xlsx', (request, response) ->
  response.sendFile 'inport-users-example.xlsx', root: '.'

module.exports = adminPCMRouter
