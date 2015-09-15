gulp = require 'gulp'
concat = require 'gulp-concat'
filter = require 'gulp-filter'
plumber = require 'gulp-plumber'
flatten = require 'gulp-flatten'
mainBowerFiles = require 'main-bower-files'
wiredep = require 'wiredep'

parameters = require '../parameters.coffee'

gulp.task 'vendor', ->
  # Scripts
  files = wiredep
      devDependencies: parameters.env is not 'production'
    .js
  gulp.src files
  .pipe filter '**/*.js'
  .pipe concat parameters.files.vendors.scripts
  .pipe gulp.dest parameters.paths.www.scripts

  # Fonts
  gulp.src [
    "#{parameters.paths.src.bower}/**/*.woff"
    "#{parameters.paths.src.bower}/**/*.svg"
    "#{parameters.paths.src.bower}/**/*.eot"
    "#{parameters.paths.src.bower}/**/*.ttf"
    "#{parameters.paths.src.bower}/**/*.otf"
  ]
  .pipe plumber()
  .pipe flatten()
  .pipe gulp.dest "#{parameters.paths.www.main}/fonts"

  gulp.src 'bower_components/ng-file-upload/FileAPI.min.js'
  .pipe gulp.dest "#{parameters.paths.www.main}/js"

  gulp.src 'bower_components/ng-file-upload/FileAPI.flash.swf'
  .pipe gulp.dest "#{parameters.paths.www.main}/flash"
