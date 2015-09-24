angular.module '%module%.landing'
.controller 'landingCtrl',  ($scope, Slider) ->

  $scope.landingCarousel = Slider.create
    catch: true
    personnel: false
    organisation: false
    technologie: false
