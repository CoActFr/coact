angular.module '%module%'
.controller 'PCMCtrl',  ($scope, $http, $sce) ->

  getDefaultAnswer = ->
    profile:
      harmoniser: false
      thinker: false
      believer: false
      doer: false
      dreamer: false
      funster: false
    justification: ""

  $scope.videos = videos
  $scope.answers = answers
  $scope.errorMsg = ""
  $scope.lastAnswerToValidate = Math.min answers.length, videos.length
  $scope.currentPage = $scope.lastAnswerToValidate
  $scope.currentAnswer = getDefaultAnswer()

  sendAnswer = (callback) ->
    req =
      method: 'POST'
      url:  window.location.href
      data:
        answer: $scope.currentAnswer
        answerNumber: $scope.currentPage
    $http req
    .then ->
      if $scope.currentPage == $scope.lastAnswerToValidate
        $scope.lastAnswerToValidate += 1
      $scope.answers[$scope.currentPage] = $scope.currentAnswer
      callback()
    , (data) ->
      $scope.errorMsg = "une erreur est survenue"

  $scope.before = ->
    $scope.answers[$scope.currentPage] = $scope.currentAnswer
    $scope.currentAnswer  = $scope.answers[$scope.currentPage-1]
    $scope.currentPage -=  1

  $scope.after = ->
    $scope.answers[$scope.currentPage] = $scope.currentAnswer
    if $scope.answers.length > $scope.currentPage
      $scope.currentAnswer  = $scope.answers[$scope.currentPage+1]
    else
      $scope.currentAnswer = getDefaultAnswer()
    $scope.currentPage += 1

  $scope.saveAndNext = ->
    sendAnswer $scope.after

  $scope.getYoutubeUrl = (embedCode) ->
    $sce.trustAsResourceUrl "https://www.youtube.com/embed/" + embedCode
