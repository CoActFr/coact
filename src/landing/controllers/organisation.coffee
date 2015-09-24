angular.module '%module%.landing'
.controller 'organisationCtrl',  ($scope, Slider) ->

  $scope.pillarCarousel = Slider.create
    first: true
    second: false
    third: false

  $scope.organisationSlider = Slider.create
    workshop: false
    transform: false
