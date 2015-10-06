gulp = require 'gulp'
webserver = require 'gulp-webserver'

parameters = require '../parameters.coffee'

gulp.task 'watch', ['build'], ->
  gulp.watch "#{parameters.paths.src.main}/**", ['build']
