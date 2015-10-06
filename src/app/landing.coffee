angular.module '%module%'
.controller 'landingCtrl',  ($scope, Slider) ->
  $scope.landingSlider = Slider.create
    catch: true
    personnel: false
    organisation: false
    technologie: false
