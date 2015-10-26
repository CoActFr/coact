# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
mongoose.connect 'mongodb://localhost/coact'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', (callback) ->

  #Schemas

  formationSchema = mongoose.Schema
    token: String
    pages: [
      validated: Boolean
      questions: [
        label: String
        mark: Number
        comments: String
      ]
    ]


  #Models

  global['formationModel'] = mongoose.model 'Formation', formationSchema


module.exports = db
