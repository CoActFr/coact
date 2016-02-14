angular.module '%module%'
.controller 'jobsCtrl',  ($scope, $http) ->
  $scope.message =
    lastname: ""
    firstname: ""
    email: ""
    phone: ""
    speach: ""

  $scope.showSuccessAlert = false
  $scope.showFailureAlert = false

  $scope.submitMessage = ->
    $scope.showSuccessAlert = false
    $scope.showFailureAlert = false
    $http
      method: 'POST'
      url: window.location.href
      data: $scope.message
    .then ->
      $scope.showSuccessAlert = true
    , (data) ->
      $scope.showFailureAlert = true

