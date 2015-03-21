gulp = require 'gulp'
path = require 'path'

config = require './config'

gulp.task 'build', (cb) ->
  runSequence = require 'run-sequence'
  runSequence(
    'clean'
    'lint'
    ['browserify:create', 'sass', 'copy']
    'usemin'
    cb
  )

gulp.task 'clean', (done) ->
  del = require 'del'
  del ['build', '.tmp'], done

gulp.task 'copy', ->
  merge = require 'merge-stream'
  streams = for src, dest of config.paths.copy
    gulp.src(src).pipe(gulp.dest(dest))
  merge.apply null, streams

gulp.task 'usemin', ->
  uglify = require 'gulp-uglify'
  minifyCss = require 'gulp-minify-css'
  minifyHtml = require 'gulp-minify-html'
  usemin = require 'gulp-usemin'
  rev = require 'gulp-rev'
  base64 = require 'gulp-base64'

  base64Options =
    baseDir: 'app/styles'
    extensions: ['svg']
    debug: true

  gulp.src('app/index.html')
    .pipe(usemin(
      css: [base64(base64Options), minifyCss(), 'concat', rev()]
      html: [minifyHtml( empty: true )]
      js: [uglify(), rev()]
    ))
    .pipe(gulp.dest('build/'))
