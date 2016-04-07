angular.module '%module%'
.controller 'adminAddFormationCtrl',  ($scope, $http) ->
  $scope.newFormation =
    title: ''
    client: ''

  $scope.submitFormation = () ->
    console.log $scope.newFormation
