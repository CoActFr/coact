angular.module '%module%'
.controller 'adminAddFormationCtrl',  ($scope, $http) ->
  $scope.newFormation =
    title: ''
    client: ''
    date: new Date Date.now()
    place: ''
    basePrice: 0

  $scope.submitFormation = () ->
    console.log $scope.newFormation
