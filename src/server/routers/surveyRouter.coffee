surveyRouter = express.Router()

surveyRouter.use (request, response, next) ->
  console.log '%s SurveyRouter: %s', request.method, request.url
  next()

###
POST
###


###
GET
###

surveyRouter.get '/:encodedToken', (request, response) ->
  surveyModel.findUserByEncodedToken request.params.encodedToken, (error, user)->
    response.render 'survey/survey',
      email: user.email

module.exports = surveyRouter
