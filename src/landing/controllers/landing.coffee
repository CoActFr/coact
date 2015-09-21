angular.module '%module%.landing'
.controller 'landingCtrl',  ($scope) ->

  $scope.landingCarousel =
    slides :
      catch:true
      personnel:false
      organisation:false
      technologie:false
    goTo : (label) ->
      @slides[label] = true
      return
