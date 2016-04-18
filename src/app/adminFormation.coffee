angular.module '%module%'
.controller 'adminAddFormationCtrl',  ($scope, $http, $confirm) ->
  now = moment 8, 'HH'
  $scope.editMode = false

  if formation
    $scope.editMode = true
    $scope.formation = formation
    #format Date into Javascript dates
    for day in $scope.formation.dates
      day.date = new Date day.date
      day.from = new Date day.from
      day.to = new Date day.to
  else
    $scope.formation =
      title: ''
      creator:
        lastname: ''
        firstname: ''
        email: ''
      client: ''
      place: ''
      basePrice: 2500
      fixedCosts: 300
      dates: [
        date: new Date now.toDate()
        from: new Date now.toDate()
        to: new Date now.add(7, 'h').toDate()
      ]
      users: []
      buyer:
        lastname: ''
        firstname: ''
        job: ''
        email: ''

  $scope.failureAlert = null

  $scope.addDay = () ->
    lastDate = $scope.formation.dates[$scope.formation.dates.length-1]
    $scope.formation.dates.push
      date: new Date lastDate.date
      from: new Date lastDate.from
      to: new Date lastDate.to

  $scope.removeDay = (day) ->
    _.pull $scope.formation.dates, day

  $scope.addUser = () ->
    $scope.formation.users.push
      lastname: ''
      firstname: ''
      email: ''

  $scope.removeUser = (user) ->
    _.pull $scope.formation.users, user


  $scope.submitFormation = () ->
    $scope.failureAlert = null
    $http
      method: 'POST'
      url: window.location.href
      data:
        formation: $scope.formation
    .then ->
      endIndex = window.location.href.lastIndexOf '/addForm'
      if $scope.editMode
        endIndex = window.location.href.lastIndexOf '/editForm'
      window.location.href = window.location.href.substring 0, endIndex
    , (data) ->
      $scope.failureAlert = '''Une erreur s'est produite lors de la création de la formation. Contactez votre super admin.'''

  $scope.destroyFormation = () ->
    $scope.failureAlert = null
    $confirm
      title: 'Êtes-vous certain de vouloir détruire cette formation ?'
      text: '(Cette action est irrévocable)'
      ok: 'Détruire la formation'
      cancel: 'Se calmer et annuler'
    .then ()->
      window.location.href
      $http
        method: 'POST'
        url: window.location.href.replace 'editForm', 'destroyForm'
        data:
          formation: $scope.formation
      .then ->
        endIndex = window.location.href.lastIndexOf '/editForm'
        window.location.href = window.location.href.substring 0, endIndex
      , (data) ->
        $scope.failureAlert = '''Une erreur s'est produite lors de la destruction de la formation. Contactez votre super admin.'''

.controller 'adminSendPostFormationCtrl',  ($scope, $http, $confirm) ->
  $scope.options =
    fiftyPercent: true
    testimony: true
    recommandation: true

  if postFormationSurveyExist
    $scope.options = postFormationSurvey.options

  $scope.switchFiftyPercent = ->
    $scope.options.fiftyPercent = !$scope.options.fiftyPercent

  $scope.switchTestimony = ->
    $scope.options.testimony = !$scope.options.testimony

  $scope.switchRecommandation = ->
    $scope.options.recommandation = !$scope.options.recommandation

  $scope.submitSendPostFormationSurvey = ->
    $scope.failureAlert = null
    chosenOption = 'Options choisies :'
    if $scope.options.fiftyPercent
      chosenOption += '\n 50% ferme + reste au choix'
    if $scope.options.testimony
      chosenOption += '\n témoignage'
    if $scope.options.recommandation
      chosenOption += '\n la recommandation auprès des partenaire'
    $confirm
      title: 'Êtes-vous certain de vouloir envoyer le questionnaire Post-Formation ?'
      text: chosenOption
      ok: 'Envoyer le questionnaire'
      cancel: 'Annuler'
    .then ()->
      window.location.href
      $http
        method: 'POST'
        url: window.location.href
        data:
          options: $scope.options
      .then ->
        location = window.location.href.replace '/sendPostFormation', '/dashboard'
        window.location.href = location
      , (data) ->
        $scope.failureAlert = '''Une erreur s'est produite lors de la destruction de la formation. Contactez votre super admin.'''
