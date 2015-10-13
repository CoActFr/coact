angular.module '%module%'
.controller 'landingCtrl',  ($scope, Slider) ->
  $scope.landingSlider = Slider.create false,
    catch: true
    personnel: false
    organisation: false
    technologie: false
