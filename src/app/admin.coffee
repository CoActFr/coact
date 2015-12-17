angular.module '%module%'
.controller 'adminSurveyFormCtrl',  ($scope) ->

  $scope.pages = pages
  $scope.currentPage = 0

  $scope.addQuestion = (page) ->
    page.questions.push
      label: ""
      allowMark: true
      allowComment: false

  $scope.addPage = ->
    newIndex = $scope.pages.length
    $scope.pages[newIndex] =
      questions: []
    $scope.addQuestion $scope.pages[newIndex]
    $scope.currentPage = newIndex


  $scope.setPage = (newIndex) ->
    $scope.currentPage = newIndex

  $scope.removeQuestion = (page, question) ->
    index = page.questions.indexOf question
    if index > -1
      page.questions.splice(index, 1)
  #todo


angular.module '%module%'
.controller 'adminSendFormCtrl',  ($scope) ->
  $scope.emails = emails
  $scope.new

  $scope.addUser = (email) ->
    $scope.emails.push email
    $scope.new = ""
