browserify = require 'browserify'
gutil = require 'gulp-util'
source = require 'vinyl-source-stream'
gulp = require 'gulp'
notify = require 'gulp-notify'

browserifyUtil =
  createBundle: (args = {}) ->
    # args.debug = true
    args.extensions = ['.coffee']
    b = browserify args

    b
      # log errors if they happen
      .on('error', (err) ->
        gutil.log('Browserify Error', err.message, err.stack)
      )

    partialify = require('partialify/custom')
    b.transform partialify.alsoAllow('json')

    b.transform require('coffeeify')
    b.transform require('debowerify')
    b.transform require('folderify')

    b.transform require('browserify-ngannotate'), x: '.coffee'

    b.transform require('brfs')

    return b

  writeBundle: (b) ->
    b.bundle()
      # log errors if they happen
      .on('error', notify.onError( (error) ->
        'Browserify Error: ' + error.message
      ))
      .pipe(source('main.js'))
      .pipe(gulp.dest('.tmp/scripts'))

module.exports = browserifyUtil
