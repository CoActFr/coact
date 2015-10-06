angular.module '%module%.landing'
.controller 'landingCtrl',  ($scope, $analytics, Slider) ->
  $analytics.pageTrack('/');

  $scope.landingSlider = Slider.create
    catch: true
    personnel: false
    organisation: false
    technologie: false
