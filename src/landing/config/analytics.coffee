angular.module '%module%.landing'
.run [
  '$rootScope'
  '$location'
  '$window'
  ($rootScope, $location, $window) ->
    $rootScope
    .$on '$stateChangeSuccess',
      (event) ->
        unless $window.ga
          return
        $window.ga 'send', 'pageview', page: $location.path()
]
