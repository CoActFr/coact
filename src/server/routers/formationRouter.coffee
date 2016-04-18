formationRouter = express.Router()

formationRouter.use (request, response, next) ->
  console.log '%s FormationRouter: %s', request.method, request.url
  next()

formationRouter.get '/:id/post', (request, response) ->
  formationModel.findById request.params.id
  .populate('postFormationSurvey.answer')
  .exec (error, formation) ->
    if error
      return response.sendStatus 500
    unless formation
      return response.sendStatus 404

    if formation.postFormationSurvey.answer
      return response.render 'formation/postformsurvey',
        formation: formation
        answer: pfsa

    pfsa = new postFormationSurveyAnswerModel
      validated: false
      chosenPrice: formation.basePrice
      testimony:
        chosen: false
        text: ''
        author: ''
        quoteCompany: false
      recommandation: false
      commentary:
        chosen: false
        text: ''

    pfsa.save (error) ->
      if error
        return response.sendStatus 500

      formation.postFormationSurvey.answer = pfsa._id
      formation.save (error) ->
        if error
          return response.sendStatus 500
        return response.render 'formation/postformsurvey',
          formation: formation
          answer: pfsa


module.exports = formationRouter
