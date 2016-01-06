angular.module '%module%'
.controller 'adminPCMCtrl',  ($scope) ->

  $scope.pcmTests = pcmTests
  $scope.addPcmTestState = 'default'
  $scope.createPcmTest = ->
    $scope.addPcmTest =
      name: ''
      videos: [
        embedCode: ''
        question: ''
      ]
    $scope.addPcmTestState = 'form'

  $scope.addVideo = ->
    $scope.addPcmTest.videos.push
      embedCode: ''
      question: ''
