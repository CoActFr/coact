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

pcmUserSchema.methods.getEncodedToken = ->
  new Buffer @ownerDocument().name + "#" + @email
  .toString('base64')


# PCM Test

pcmTestSchema = mongoose.Schema
  name: String
  videos: [pcmVideoSchema]
  users: [pcmUserSchema]

###
  callback : (error, user) -> do something
###
pcmTestSchema.statics.findUserByEncodedToken = (encodedToken, callback) ->
  [name, email] = new Buffer(encodedToken, 'base64').toString('ascii').split("#")
  @findOne name: name
  .exec (error, pcmTest) ->
    if error
      return callback error, null
    user =  _.find pcmTest.users, 'email', email
    if user is undefined
      return callback "Error: user " + email + " is undefined", null
    callback null, user

### Models ###

global['pcmVideoModel'] = mongoose.model 'PCMVideo', pcmVideoSchema
global['pcmAnswerModel'] = mongoose.model 'PCMAnswer', pcmAnswerSchema
global['pcmUserModel'] = mongoose.model 'PCMUser', pcmUserSchema
global['pcmTestModel'] = mongoose.model 'PCMTest', pcmTestSchema
