angular.module '%module%'
.controller 'adminPCMCtrl',  ($scope, $http) ->

  $scope.pcmTests = pcmTests
  $scope.addPcmTestState = 'default'
  $scope.errorMsg = ""
  $scope.currentPage = 0

  $scope.createPcmTest = ->
    $scope.addPcmTest =
      name: ''
      videos: [
        embedCode: ''
        question: ''
      ]
    $scope.errorMsg = ""
    $scope.addPcmTestState = 'form'

  $scope.addVideo = ->
    $scope.addPcmTest.videos.push
      embedCode: ''
      question: ''
    $scope.currentPage += 1

  $scope.before = ->
    $scope.currentPage -= 1

  $scope.after = ->
    $scope.currentPage += 1


  $scope.saveTest = ->
    unless $scope.addPcmTest.name
      return $scope.errorMsg = "il faut un nom au questionnaire"

    url = window.location.host + "/admin/pcm/add"
    unless url.substring(0, 7) == 'http://'
      url = 'http://' + url
    req =
      method: 'POST'
      url:  url
      data: $scope.addPcmTest
    $http req
    .then ->
      $scope.pcmTests.push $scope.addPcmTest.name
      $scope.addPcmTestState = 'default'
    , (data) ->
      switch data.status
        when 409
          $scope.errorMsg = "name " + $scope.addPcmTest.name + " already exist"
        else
          $scope.errorMsg = "erreur"


angular.module '%module%'
.controller 'seePCMCtrl',  ($scope) ->
  $scope.currentPage = 0
  $scope.numberOfVideos = numberOfVideos

  $scope.next = ->
    $scope.currentPage += 1

  $scope.previous = ->
    $scope.currentPage -= 1



angular.module '%module%'
.controller 'sendPCMCtrl',  ($scope, $http) ->
  $scope.tryToSend = false
  $scope.emailToSend = ""
  $scope.errorMsg = false
  $scope.successMsg = false

  $scope.sendEmail = ->
    $scope.tryToSend = true
    $scope.successMsg = false
    if $scope.sendEmailForm.$valid
      $http
        method: 'POST'
        url: window.location.href
        data:
          email: $scope.emailToSend
      .then ->
        $scope.tryToSend = false
        $scope.emailToSend = ""
        $scope.successMsg = true
      , (data) ->
        $scope.errorMsg = true


