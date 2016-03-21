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

# Correct

angular.module '%module%'
.controller 'correctPCMCtrl',  ($scope, $sce, $http) ->
  $scope.answers = answers
  $scope.videos = videos
  $scope.name = name

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
  $scope.showGenericSuccessAlert = false
  $scope.showGenericFailureAlert = false

  $scope.pushGeneric = (index) ->
    $scope.corrections[index].comment = $scope.videos[index].genericAnswer

  $scope.pullGeneric = (index) ->
    $scope.videos[index].genericAnswer = $scope.corrections[index].comment

  $scope.updateGeneric = (index) ->
    url = window.location.href
    url = _(url).replace '/correct', '/update-generic'
    questionMark = url.lastIndexOf '?'
    if questionMark > 0
      url = url[0..questionMark-1]
    url += "/" + index

    $scope.showGenericSuccessAlert = false
    $scope.showGenericFailureAlert = false

    $http
      method: 'POST'
      url: url
      data:
        genericAnswer: $scope.videos[index].genericAnswer
    .then ->
      $scope.showGenericSuccessAlert = true
    , (data) ->
      $scope.showGenericFailureAlert = true

  $scope.getYoutubeUrl = (index) ->
    $sce.trustAsResourceUrl "https://www.youtube.com/embed/" + $scope.videos[index].embedCode

  $scope.changeVideo = (index) ->
    $scope.selectedVideo = index

  $scope.closeVideo = ->
    $scope.selectedVideo = null

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


