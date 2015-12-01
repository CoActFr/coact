angular.module '%module%'
.controller 'surveyFormCtrl',  ($scope) ->

  $scope.questions = questions
  $scope.markRange = [0..10]

