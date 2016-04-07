# pcm Video

formationSchema = mongoose.Schema
  title: String
  client: String
  date: Date
  place: String
  basePrice: Number


global['formationModel'] = mongoose.model 'Formation', formationSchema
