# Formation

userSchema = mongoose.Schema
  lastname: String
  firstname: String
  email: String

formationSchema = mongoose.Schema
  creator:
    lastname: String
    firstname: String
    email: String
  title: String
  client: String
  dates: [
    date: Date
    from: Date
    to: Date
  ]
  users: [userSchema]
  place: String
  basePrice: Number
  fixedCosts: Number
  buyer:
    lastname: String
    firstname: String
    job: String
    email: String
  postFormationSurvey: ObjectId

postFormationSurveySchema = mongoose.Schema
  sent: Boolean
  options:
    fiftyPercent: Boolean
    recommandation: Boolean
    testimony: Boolean
  answer: ObjectId

postFormationSurveyAnswerSchema = mongoose.Schema
  validated: Boolean
  chosenPrice: Number
  testimony:
    chosen: Boolean
    text: String
    authorOption: Number
    quoteCompany: Boolean
  recommandation: Boolean
  commentary:
    chosen: Boolean
    text: String


global['userModel'] = mongoose.model 'User', userSchema


global['formationModel'] = mongoose.model 'Formation', formationSchema
global['postFormationSurveyModel'] = mongoose.model 'PostFormationSurvey', postFormationSurveySchema
global['postFormationSurveyAnswerModel'] = mongoose.model 'PostFormationSurveyAnswer', postFormationSurveyAnswerSchema
