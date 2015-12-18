angular.module '%module%'
.controller 'surveyFormCtrl', ($scope, $http) ->

  $scope.pages = pages
  $scope.currentPage = 0

  $scope.markLabel = [
    'ne se prononce pas'
    [1..10]...
  ]
  $scope.displayMark = (mark) ->
    $scope.markLabel[mark]

  $scope.setPage = (newIndex) ->
    $scope.currentPage = newIndex

  $scope.sendTest = (encodedToken) ->
    url = window.location.host + "/survey/test/" + encodedToken
    unless url.substring(0, 7) == 'http://'
      url = 'http://' + url
    req =
      method: 'POST'
      url: url
      #headers:
      # 'Content-Type': undefined
      data: pages
    $http req
    .then ->
      console.log "sucess"
    , ->
      console.log "error"

angular.module '%module%'
.directive 'questionMark', ($timeout) ->

  markDirective =
    restrict: "C"
    template: ['<input id="mark-slider-{{$parent.$index}}-{{$index}}"
        type="text"
        slider-directive data-slider-min="0"
        data-slider-max="{{markLabel.length-1}}"
        data-slider-step="1"
        data-slider-value="{{question.answer.mark}}" />
      <span class="displayed-mark">
        {{displayMark(question.answer.mark)}}
      </span>']
    link: (scope, element, attr) ->
      sliderId = "#mark-slider-" + scope.$parent.$index + "-" + scope.$index
      $timeout ->
        slider = new Slider sliderId
        slider.on "slide", (slideEvt) ->
          scope.question.answer.mark = slideEvt.valueOf()
          scope.$apply()

