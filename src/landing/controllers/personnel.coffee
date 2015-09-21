angular.module '%module%.landing'
.controller 'personnelCtrl',  ($scope, Carousel) ->

  $scope.personnelCarousel = Carousel.create
    catch:true
    personnel:false
    organisation:false
    technologie:false
