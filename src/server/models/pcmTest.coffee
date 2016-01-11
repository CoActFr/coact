# pcm Video

pcmVideoSchema = mongoose.Schema
  embedCode: String
  question: String

# pcm Answer

pcmAnswerSchema = mongoose.Schema
  profile:
    harmoniser: Boolean
    thinker: Boolean
    believer: Boolean
    doer: Boolean
    dreamer: Boolean
    funster: Boolean
  justification: String

# PCM User

pcmUserSchema = mongoose.Schema
  email: String
  answers: [pcmAnswerSchema]



# PCM Test

pcmTestSchema = mongoose.Schema
  name: String
  videos: [pcmVideoSchema]
  users: [pcmUserSchema]

pcmTestSchema.methods.getEncodedToken = (email) ->
  new Buffer @.name + "#" + email.toLowerCase()
  .toString('base64')

###
  callback : (error, user) -> do something
###
pcmTestSchema.statics.getOrCreateUserFromToken = (token, callback) ->
  [name, email] = new Buffer(token, 'base64').toString('ascii').split("#")
  @findOne name: name
  .exec (error, pcmTest) ->
    if error
      return callback error, null
    user =  _.find pcmTest.users, 'email', email
    if user is undefined
      pcmTest.users.push new pcmUserModel
        email: email
        answers: []

      pcmTest.save (error) ->
        if error
          return callback "Error: user " + email + " cannot be created", null
        callback null, user
    else
      callback null, user

### Models ###

global['pcmVideoModel'] = mongoose.model 'PCMVideo', pcmVideoSchema
global['pcmAnswerModel'] = mongoose.model 'PCMAnswer', pcmAnswerSchema
global['pcmUserModel'] = mongoose.model 'PCMUser', pcmUserSchema
global['pcmTestModel'] = mongoose.model 'PCMTest', pcmTestSchema
