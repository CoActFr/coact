angular.module '%module%.landing'
.factory 'Carousel',
() ->
  create : (slides) ->
    slides : slides
    goTo : (label) ->
      @slides[label] = true
      return
