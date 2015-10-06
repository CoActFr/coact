angular.module '%module%'
.factory 'Slider',
() ->
  create : (slides) ->
    slides : slides
    goTo : (label) ->
      for slide of @slides
        @slides[slide] = false
      @slides[label] = true
      return
