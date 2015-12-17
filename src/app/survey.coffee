angular.module '%module%'
.controller 'surveyFormCtrl', ($scope, $http) ->

  $scope.pages = pages
  $scope.currentPage = 0

  $scope.markRange = [0..10]

  $scope.setPage = (newIndex) ->
    $scope.currentPage = newIndex

  $scope.sendTest = (encodedToken) ->
    url = window.location.host + "/survey/test/" + encodedToken
    unless url.substring(0, 7) == 'http://'
      url = 'http://' + url
    req =
      method: 'POST'
      url: url
      #headers:
      # 'Content-Type': undefined
      data: pages
    $http req
    .then ->
      console.log "sucess"
    , ->
      console.log "error"

