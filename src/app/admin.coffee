angular.module '%module%'
.controller 'adminSurveyFormCtrl',  ($scope) ->

  $scope.getMark = (question) ->
    if question.mark.value == -1 then 'en attente de réponse' else question.mark.value

  $scope.pages = pages
  $scope.currentPage = 0

  $scope.addQuestion = (page) ->
    page.questions.push
      label: ""
      mark:
        allow: true
        value: -1
      comment:
        allow: false
        text: ""

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
