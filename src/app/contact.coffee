angular.module '%module%'
.controller 'contactCtrl',  ($scope, $http) ->
  $scope.message =
    lastname: ""
    firstname: ""
    organisation: ""
    fonction: ""
    email: ""
    phone: ""
    interests:
      collaborativeTraining: false
      seminar: false
      openForum: false
      learningOrganisation: false
      technologies: false
      others: false
    details: ""

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

