# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
mongoose.connect 'mongodb://localhost/coact'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', (callback) ->

  #Schemas
  questionSchema = mongoose.Schema
    label: String
    mark:
      allow: Boolean
      value: Number
    comment:
      allow: Boolean
      text: String

  pageSchema = mongoose.Schema
    questions: [questionSchema]

  formationSchema = mongoose.Schema
    token: String
    validated: Boolean
    pages: [pageSchema]



  #Models

  global['questionModel'] = mongoose.model 'Question', questionSchema
  global['pageModel'] = mongoose.model 'Page', pageSchema
  global['formationModel'] = mongoose.model 'Formation', formationSchema


module.exports = db
