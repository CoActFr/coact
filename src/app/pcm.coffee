angular.module '%module%'
.controller 'PCMCtrl',  ($scope, $http, $sce) ->

  $scope.userFirstname = user.firstname
  $scope.userLastname = user.lastname

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
  if $scope.lastAnswerToValidate > 0
    $scope.currentPage = $scope.lastAnswerToValidate
  else
    $scope.currentPage = -1
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
    if $scope.currentPage > 0
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

  updateUser = ->
    req =
      method: 'POST'
      url:  window.location.href.replace 'pcm', 'pcm/update-user'
      data:
        firstname: $scope.userFirstname
        lastname: $scope.userLastname
    $http req
    .then ->
      $scope.currentPage = 0
    , (data) ->
      $scope.errorMsg = "une erreur est survenue"

  $scope.saveAndNext = ->
    if $scope.currentPage >= 0
      sendAnswer $scope.after
    else
      updateUser()


  $scope.getYoutubeUrl = (embedCode) ->
    $sce.trustAsResourceUrl "https://www.youtube.com/embed/" + embedCode
