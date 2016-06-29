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

## Variables
config =
  bowerDir: './bower_components'
  path:
    build:
      html: './build'
      js: './build'
      css: './build/css'
      images: './build/images'
    src:
      js: './src/javascript/widget.js'
      css: './src/stylesheets/widget.scss'
      jade: './src/templates/widget.jade'
      index: './src/index.jade'
    watch:
      js: './src/javascript/*.js'
      coffee: './src/javascript/*.coffee'
      scss: './src/stylesheets/**/*.scss'
    clean: './build/js'
    tmp: './tmp'
  server:
    server:
      baseDir: "./build"
    tunnel: false
    host: 'localhost'
    port: 9000
    logPrefix: "NodeBuilder"
    open: false
    reloadDebounce: 5000

## Jade build
gulp.task 'index:build', ()->
  gulp.src config.path.src.index
  .pipe rigger()
  .pipe jade({pretty: true})
  .pipe gulp.dest config.path.build.html

gulp.task 'jade:build', ()->
  gulp.src config.path.src.jade
  .pipe rigger()
  .pipe jade({pretty: true})
  .pipe htmlmin({collapseWhitespace: true})
  .pipe gulp.dest config.path.tmp

## CSS build
gulp.task 'style:build', ()->
  gulp.src config.path.src.css
  .pipe sass {
    style: 'nested',
    loadPath: [
      './src/stylesheets/',
      config.bowerDir + '/bootstrap-sass/assets/stylesheets'
    ]
  }
  .pipe cssclean {keepSpecialComments: 0}
  .pipe replace /'/g, '"'
  .pipe gulp.dest config.path.build.css
  .pipe reload({stream: true})

## JS build
gulp.task 'js:build', ()->
  gulp.src [
    './bower_components/jquery/dist/jquery.min.js',
    './bower_components/bootstrap/dist/js/bootstrap.min.js',
    './bower_components/handlebars/handlebars.min.js',
    './bower_components/alpaca/dist/alpaca/bootstrap/alpaca.min.js'
    './src/javascript/widget.coffee'
  ]
  .pipe gulpif(/[.]coffee$/, coffee({bare: true}))
  .pipe fileinclude({
    prefix: '@@',
    basepath: '@file'
  })
  .pipe concat 'widget.js'
  .pipe gulp.dest config.path.build.js
  .pipe reload({stream: true})

gulp.task 'js:build-minify', ()->
  gulp.src [
    './bower_components/jquery/dist/jquery.js',
    './bower_components/fetch/fetch.js',
    './bower_components/promise-polyfill/Promise.js',
    './bower_components/webcall-mobilon.js/js/webcall.js',
    './src/javascript/widget.coffee'
  ]
  .pipe gulpif(/[.]coffee$/, coffee({bare: true}))
  .pipe fileinclude({
    prefix: '@@',
    basepath: '@file'
  })
  .pipe uglify()
  .pipe concat 'widget.min.js'
  .pipe gulp.dest config.path.build.js

## Clean
gulp.task 'clean:tmp', (cb)->
  rimraf(config.path.tmp, cb)
gulp.task 'clean:build', (cb)->
  rimraf(config.path.clean, cb)

## Watch
gulp.task 'watch', ()->
  gulp.watch [config.path.watch.coffee], ['js:build', 'js:build-minify']
  gulp.watch [config.path.watch.scss], ['build:widget']

## Build
gulp.task 'build:all', [
  'style:build',
  'index:build',
  'jade:build',
  'js:build',
  'js:build-minify'
]

gulp.task 'build:widget', [
  'style:build',
  'js:build',
  'js:build-minify'
]

## Web
gulp.task 'webserver', ()->
  browerSync(config.server)

## Init
gulp.task 'run', ['build:all', 'webserver', 'watch']
gulp.task 'default', ['build:all']