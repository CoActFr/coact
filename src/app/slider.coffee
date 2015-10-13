angular.module '%module%'
.factory 'Slider', [ '$anchorScroll',
($anchorScroll) ->
  create : (anchor, slides) ->
    slides : slides
    anchor : anchor
    goTo : (label) ->
      for slide of @slides
        @slides[slide] = false
      @slides[label] = true
      if @anchor
        $anchorScroll @anchor
      return
]
