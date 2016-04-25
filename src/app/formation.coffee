angular.module '%module%'
.controller 'postFormationCtrl',  ($scope, $http, $confirm) ->
  $scope.fixedFiftyPrice = Math.floor(basePrice/2)
  $scope.maxChosenPrice = 2*basePrice
  $scope.fixedCosts = fixedCosts
  $scope.answer = answer
  $scope.buyer = buyer
  $scope.client = client

  $scope.updateMaxChosenPrice = ->
    if $scope.answer.chosenPrice >= $scope.maxChosenPrice
      $scope.maxChosenPrice = $scope.answer.chosenPrice + $scope.fixedFiftyPrice

  $scope.getTotal = ->
    return Math.floor($scope.fixedFiftyPrice + $scope.fixedCosts + $scope.answer.chosenPrice)

  $scope.testify = ->
    $scope.answer.testimony.chosen = not $scope.answer.testimony.chosen

  $scope.selectAuthorOption = (option) ->
    $scope.answer.testimony.authorOption = option

  initialize = (name) ->
    words = _.words(name)
    initials = ''
    for word in words
      initials += word[0].toUpperCase() + '.'
    return initials

  $scope.getAuthorOption = (option) ->
    switch option
      when 0 then return $scope.buyer.firstname + ' ' + $scope.buyer.lastname + ', ' + $scope.buyer.job
      when 1 then return $scope.buyer.firstname + ' ' + initialize($scope.buyer.lastname) + ', ' + $scope.buyer.job
      when 2 then return initialize($scope.buyer.firstname) + initialize($scope.buyer.lastname) + ', ' + $scope.buyer.job
      when 3 then return initialize($scope.buyer.firstname) + initialize($scope.buyer.lastname)

  $scope.quoteCompany = (choice) ->
    $scope.answer.testimony.quoteCompany = choice

  $scope.recommand =  ->
    $scope.answer.recommandation.chosen = not $scope.answer.recommandation.chosen

  getEmptyContact = ->
    return {
      firstname: ''
      lastname: ''
      company: ''
      job: ''
      phone: ''
      email: ''
    }

  $scope.contactArray = $scope.answer.recommandation.contacts
  $scope.contactArray.push getEmptyContact()
  while $scope.contactArray.length < 3
    $scope.contactArray.push getEmptyContact()

  $scope.addContact = (index) ->
    if index == $scope.contactArray.length - 1
      $scope.contactArray.push getEmptyContact()

  $scope.comment = ->
    $scope.answer.commentary.chosen = not $scope.answer.commentary.chosen

  $scope.failureAlert = false
  $scope.submitPostFormationSurvey = ->
    #remove empty recommandations
    $scope.answer.recommandation.contacts = _.reject $scope.contactArray, (contact)->
      return not (contact.firstname or
       contact.lastname or
       contact.company or
       contact.job or
       contact.phone or
       contact.email)

    $scope.failureAlert = false
    $http
      method: 'POST'
      url: window.location.href
      data:
        answer: $scope.answer
        client: $scope.client
    .then ->
      window.location.href = window.location.href.replace 'post', 'thanks'
    , (data) ->
      $scope.failureAlert = true
