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

# Web server
browerSync  = require 'browser-sync'
reload      = browerSync.reload

# Minifiers
cssclean    = require 'gulp-clean-css'
uglify      = require 'gulp-uglify'
htmlmin     = require 'gulp-html-minifier'