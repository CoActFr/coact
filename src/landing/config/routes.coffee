angular.module '%module%.landing'
.config ($stateProvider) ->
  $stateProvider
  .state 'landing',
    url: '/'
    controller: 'landingCtrl'
    templateUrl: 'landing/views/landing.html'
    parent: 'app'
  .state 'personnel',
    url: '/personnel'
    controller: 'personnelCtrl'
    templateUrl: 'landing/views/personnel.html'
    parent: 'app'
  .state 'organisation',
    url: '/organisation'
    templateUrl: 'landing/views/organisation.html'
    controller: 'organisationCtrl'
    parent: 'app'
  .state 'technologie',
    url: '/technologie'
    templateUrl: 'landing/views/technologie.html'
    parent: 'app'
  .state 'contact',
    url: '/contact'
    templateUrl: 'landing/views/contact.html'
    parent: 'app'
