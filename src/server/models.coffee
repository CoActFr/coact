# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
mongoose.connect 'mongodb://localhost/coact'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', (callback) ->

  ###
                          Survey
                            |
       SurveyTemplate  ------------- SurveyUser
            |                             |
          Pages              Answers ------------ TempAnswers
            |
        Questions
  ###


  ### Schemas ###


  # basic Question

  basicQuestionSchema = mongoose.Schema
    label: String
    allowMark: Boolean
    allowComment: Boolean

  # basic Answer

  basicAnswerSchema = mongoose.Schema
    mark:
      type: Number
      min: -1
      max: 10
    comment: String

  # Page

  pageSchema = mongoose.Schema
    questions: [basicQuestionSchema]

  # Survey Template

  surveyTemplateSchema = mongoose.Schema
    pages: [pageSchema]

  # Answer

  answerSchema = mongoose.Schema
    questionId: mongoose.Schema.Types.ObjectId
    answer:
      type: mongoose.Schema.ObjectId
      ref: 'BasicAnswer'

  # Survey User

  surveyUserSchema = mongoose.Schema
    email: String
    tempAnswers: [answerSchema]
    answers: [answerSchema]

  # Survey

  surveySchema = mongoose.Schema
    token: String
    template:
      type: mongoose.Schema.ObjectId
      ref: 'SurveyTemplate'
    users: [surveyUserSchema]



  ### Models ###

  global['basicQuestionModel'] = mongoose.model 'BasicQuestion', basicQuestionSchema
  global['basicAnswerModel'] = mongoose.model 'BasicAnswer', basicAnswerSchema
  global['pageModel'] = mongoose.model 'Page', pageSchema
  global['answerModel'] = mongoose.model 'Answer', answerSchema
  global['surveyTemplateModel'] = mongoose.model 'SurveyTemplate', surveyTemplateSchema
  global['surveyUserModel'] = mongoose.model 'SurveyUser', surveyUserSchema
  global['surveyModel'] = mongoose.model 'Survey', surveySchema


module.exports = db
