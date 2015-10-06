angular.module '%module%.landing'
.controller 'personnelCtrl',  ($scope, $analytics, Slider) ->
  $analytics.pageTrack('/personnel');

  $scope.personnelSlider = Slider.create
    takeAction: true
    transform: false
    discover: false
