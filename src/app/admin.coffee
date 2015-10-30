angular.module '%module%'
.controller 'adminSurveyFormCtrl',  ($scope) ->

  $scope.getMark = (question) ->
    if question.mark.value == -1 then 'en attente de réponse' else question.mark.value

  $scope.pages = pages

  $scope.addQuestion = (page) ->
    page.questions.push
      label: ""
      mark:
        allow: true
        value: -1
      comment:
        allow: false
        text: ""

  $scope.removeQuestion = (page, question) ->
    index = page.questions.indexOf question
    if index > -1
      page.questions.splice(index, 1)
  #todo
