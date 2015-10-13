angular.module '%module%'
.controller 'organisationCtrl',  ($scope, Slider) ->
  $scope.organisationSlider = Slider.create 'body',
    workshop: false
    transform: false
