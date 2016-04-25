formationRouter = express.Router()

formationRouter.use (request, response, next) ->
  console.log '%s FormationRouter: %s', request.method, request.url
  next()

formationRouter.get '/:id/post', (request, response) ->
  formationModel.findById request.params.id
  .populate('postFormationSurvey')
  .exec (error, formation) ->
    if error
      return response.sendStatus 500
    unless formation
      return response.sendStatus 404

    if formation.postFormationSurvey.answer
      formation.postFormationSurvey
      .populate 'answer', (error, pfs) ->
        if error
          return response.sendStatus 500
        return response.render 'formation/postformsurvey',
          formation: formation
          answer: pfs.answer

    else
      pfsa = new postFormationSurveyAnswerModel
        validated: false
        chosenPrice: Math.floor(50*formation.basePrice)/100
        testimony:
          chosen: false
          text: ''
          authorOption: 0
          quoteCompany: true
        recommandation:
          chosen: false
          contacts: []
        commentary:
          chosen: false
          text: ''

      pfsa.save (error) ->
        if error
          return response.sendStatus 500

        formation.postFormationSurvey.answer = pfsa._id
        formation.postFormationSurvey.save (error) ->
          if error
            return response.sendStatus 500
          return response.render 'formation/postformsurvey',
            formation: formation
            answer: pfsa


formationRouter.post '/:id/post', (request, response) ->
  answer = request.body.answer

  if answer.chosenPrice < 0 or answer.testimony.authorOption not in [0..3]
    return response.sendStatus 400

  formationModel.findOneAndUpdate
    _id: request.params.id,
    client: request.body.client
  .populate('postFormationSurvey')
  .exec (error, formation) ->
    if error
      return response.sendStatus 500

    postFormationSurveyAnswerModel.findOneAndUpdate
      _id: formation.postFormationSurvey.answer,
      answer, (error, savedAnswer) ->
        if error
          return response.sendStatus 500
        return response.sendStatus 200


module.exports = formationRouter
