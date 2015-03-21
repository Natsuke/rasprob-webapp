config = require './config'
gulp = require 'gulp'
gutil = require 'gulp-util'



gulp.task 'lint', ->
  coffeelint = require 'gulp-coffeelint'
  plumber = require 'gulp-plumber'

  gulp.src(config.paths.scripts.all)
    .pipe(plumber())
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(coffeelint.reporter('fail'))

gulp.task 'lint:watch', ->
  gulp.watch config.paths.scripts.all, ['lint']





browserifyCreateBundle = (args) ->
  butil = require './browserify-util'
  b = butil.createBundle(args)
  b.add './app/scripts/main.coffee'
  return b

browserifyCreate = (options) ->
  butil = require './browserify-util'
  b = browserifyCreateBundle()

  if options.transforms
    options.transforms.forEach b.transform.bind(b)

  createNgConstant()
  butil.writeBundle b

browserifyWatch = ->
  watchify = require 'watchify'
  source = require 'vinyl-source-stream'
  prettyHrtime = require 'pretty-hrtime'
  notify = require 'gulp-notify'

  b = watchify(browserifyCreateBundle(watchify.args))

  rebundle = ->
    gutil.log('Rebundle...')
    start = process.hrtime()

    return b.bundle()
      # log errors if they happen
      .on('error', notify.onError( (error) ->
        'Browserify Error: ' + error.message
      ))
      .pipe(source('main.js'))
      .pipe(gulp.dest('.tmp/scripts'))
      .pipe(notify(->
        end = process.hrtime(start)
        "Rebundle done. (#{prettyHrtime(end)})"
      ))

  b.on 'update', rebundle
  rebundle()

browserifyWatchSpawn = ->
  createNgConstant()

  {spawn} = require 'child_process'
  child = spawn 'gulp', ['browserify:watch'], stdio: 'inherit'
  process.on 'exit', -> child.kill()

gulp.task 'browserify:create', browserifyCreate
gulp.task 'browserify:watch', browserifyWatch
gulp.task 'browserify:watch:spawn', browserifyWatchSpawn



createNgConstant = ->
  ngConstant = require 'gulp-ng-constant'
  args = require('yargs')
          .defaults('apiurl', '/api')
          .argv

  ngConstant(
    name: 'web-app'
    deps: false
    wrap: 'commonjs'
    constants:
      apiUrl: args.apiurl
    stream: true
  )
    .pipe(gulp.dest('app/scripts'))
