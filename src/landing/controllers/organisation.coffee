angular.module '%module%.landing'
.controller 'organisationCtrl',  ($scope, $analytics, Slider) ->
  $analytics.pageTrack('/organisation');

  $scope.pillarCarousel = Slider.create
    first: true
    second: false
    third: false

  $scope.organisationSlider = Slider.create
    workshop: false
    transform: false
