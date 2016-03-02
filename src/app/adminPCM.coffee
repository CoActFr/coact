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


# SEE

angular.module '%module%'
.controller 'seePCMCtrl',  ($scope) ->
  $scope.currentPage = 0
  $scope.numberOfPages = numberOfPages

  $scope.next = ->
    $scope.currentPage += 1

  $scope.previous = ->
    $scope.currentPage -= 1

# Correct

angular.module '%module%'
.controller 'correctPCMCtrl',  ($scope, $sce, $http) ->
  $scope.answers = answers
  $scope.videos = videos
  $scope.corrections = []
  $scope.corrections.push {
    profile:
      harmoniser: answer.profile.harmoniser
      thinker: answer.profile.thinker
      believer: answer.profile.believer
      doer: answer.profile.doer
      dreamer: answer.profile.dreamer
      funster: answer.profile.funster
    comment: ""
    } for answer in answers
  $scope.selectedVideo = null

  $scope.showSuccessAlert = false
  $scope.showFailureAlert = false

  $scope.getYoutubeUrl = (index) ->
    $sce.trustAsResourceUrl "https://www.youtube.com/embed/" + $scope.videos[index].embedCode

  $scope.changeVideo = (index) ->
    $scope.selectedVideo = index

  $scope.submitCorrection = ->
    $scope.showSuccessAlert = false
    $scope.showFailureAlert = false
    $http
      method: 'POST'
      url: window.location.href
      data: $scope.corrections
    .then ->
      $scope.showSuccessAlert = true
    , (data) ->
      $scope.showFailureAlert = true

# SEND

angular.module '%module%'
.controller 'sendPCMCtrl',  ($scope, $http) ->
  $scope.tryToSend = false
  $scope.emailToSend = ""
  $scope.firstnameToSend = ""
  $scope.lastnameToSend = ""
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
          firstname: $scope.firstnameToSend
          lastname: $scope.lastnameToSend
      .then ->
        $scope.tryToSend = false
        $scope.emailToSend = ""
        $scope.firstnameToSend = ""
        $scope.lastnameToSend = ""
        $scope.successMsg = true
      , (data) ->
        $scope.errorMsg = true


