angular.module '%module%'
.controller 'personnelCtrl',  ($scope, Slider) ->
  $scope.personnelSlider = Slider.create 'side-slider',
    takeAction: true
    transform: false
    discover: false
