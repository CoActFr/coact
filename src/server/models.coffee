# DB

global['mongoose'] = require '../node_modules/mongoose/index.js'
global['ObjectId'] = mongoose.Schema.Types.ObjectId
mongoose.connect 'mongodb://localhost/coact'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', (callback) ->

  require './%models%/pcmTest.js'
  require './%models%/formation.js'

module.exports = db
