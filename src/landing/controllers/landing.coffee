angular.module '%module%.landing'
.controller 'landingCtrl',  ($scope, Carousel) ->

  $scope.landingCarousel = Carousel.create
    catch:true
    personnel:false
    organisation:false
    technologie:false
