angular.module '%module%'
.controller 'surveyFormCtrl',  ($scope) ->

  $scope.getMark = (question) ->
    if question.mark.value == -1 then 'en attente de réponse' else question.mark.value

  $scope.getComment = (question) ->
    if question.comment.text == "false" then 'en attente de réponse' else question.comment.text
  $scope.pages = pages
  #todo
