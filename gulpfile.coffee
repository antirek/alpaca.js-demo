gulp        = require 'gulp'
rimraf      = require 'rimraf'
concat      = require 'gulp-concat'
gulpif      = require 'gulp-if'
replace     = require 'gulp-replace'

# Coffee
coffee      = require 'gulp-coffee'

# SASS, HAML
jade        = require 'gulp-pug'
sass        = require 'gulp-sass'

# Include into
rigger      = require 'gulp-rigger'
fileinclude = require 'gulp-file-include'


# Minifiers
cssclean    = require 'gulp-clean-css'
uglify      = require 'gulp-uglify'
htmlmin     = require 'gulp-html-minifier'


gulp.task 'js:build', ()->
  gulp.src [
    './bower_components/jquery/dist/jquery.min.js',
    './bower_components/bootstrap/dist/js/bootstrap.min.js',
    './bower_components/handlebars/handlebars.min.js',
    './bower_components/alpaca/dist/alpaca/bootstrap/alpaca.min.js'
  ]
  .pipe fileinclude({
    prefix: '@@',
    basepath: '@file'
  })
  .pipe concat 'widget.js'
  .pipe gulp.dest 'build'
  #.pipe reload({stream: true})