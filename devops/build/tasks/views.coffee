gulp = require 'gulp'
plumber = require 'gulp-plumber'
flatten = require 'gulp-flatten'
replace = require 'gulp-replace'

parameters = require '../parameters.coffee'

gulp.task 'views', ->
  gulp.src "#{parameters.paths.src.views}/**/*.jade"
  .pipe plumber()
  .pipe parameters.angular.module.replacer replace
  .pipe parameters.folders.scripts.replacer replace
  .pipe parameters.folders.styles.replacer replace
  #.pipe flatten()
  .pipe gulp.dest "#{parameters.paths.www.views}"
