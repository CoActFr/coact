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
  buyer:
    lastname: String
    firstname: String
    job: String
    email: String


global['userModel'] = mongoose.model 'User', userSchema


global['formationModel'] = mongoose.model 'Formation', formationSchema
