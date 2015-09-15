gulp = require 'gulp'
plumber = require 'gulp-plumber'
flatten = require 'gulp-flatten'
less = require 'gulp-less'

parameters = require '../parameters.coffee'

gulp.task 'assets', ->
  gulp.src "#{parameters.paths.src.assets}/**"
    .pipe plumber()
    .pipe gulp.dest parameters.paths.www.main

  gulp.src [
    "#{parameters.paths.src.images}/*.png"
    "#{parameters.paths.src.images}/*.svg"
    ]
    .pipe plumber()
    .pipe flatten()
    .pipe gulp.dest parameters.paths.www.img

  gulp.src "#{parameters.paths.src.less}/*.less"
      .pipe less
        paths: [ parameters.paths.src.bower ]
      .pipe gulp.dest parameters.paths.www.styles
