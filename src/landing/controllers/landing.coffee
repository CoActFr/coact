angular.module '%module%.landing'
.controller 'landingCtrl',  ($scope) ->

  $scope.landingCarousel =
    catch:true
    personnel:false
    organisation:false
    technologie:false
    goTo : (label) ->
      this[label] = true
      return
