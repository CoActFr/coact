angular.module '%module%'
.controller 'personnelCtrl',  ($scope, Slider) ->
  $scope.personnelSlider = Slider.create 'slider-controller',
    takeAction: true
    transform: false
    discover: false
