gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
plumber = require 'gulp-plumber'
replace = require 'gulp-replace'
sourcemaps = require 'gulp-sourcemaps'
wiredep = require('wiredep').stream
injectConfig = require './inject-config'

parameters = require '../parameters.coffee'

gulp.task 'server', ['routers'], ->
  stream = gulp.src "#{parameters.paths.src.server.main}/server.coffee"
  .pipe plumber()

  injectConfig stream
  .pipe parameters.folders.scripts.replacer replace
  .pipe parameters.folders.styles.replacer replace
  .pipe parameters.folders.routers.replacer replace
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
  .pipe sourcemaps.write()
  .pipe gulp.dest parameters.paths.www.main

gulp.task 'routers', ->
  stream = gulp.src [
    "#{parameters.paths.src.server.routers}/*.coffee"
  ]
  .pipe plumber()

  injectConfig stream
  .pipe parameters.folders.scripts.replacer replace
  .pipe parameters.folders.styles.replacer replace
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
  .pipe sourcemaps.write()
  .pipe gulp.dest parameters.paths.www.routers
