gulp = require 'gulp'
gutil = require 'gulp-util'
runSequence = require 'run-sequence'
source = require 'vinyl-source-stream'
path = require 'path'
_ = require 'lodash'

config = require './config'
getPort = config.www.getPort





gulp.task 'test', ['lint', 'karma', 'protractor']
gulp.task 'test:build', (cb) ->
  runSequence(
    'protractor:setup'
    'server:build:start'
    'protractor:run'
    'server:stop'
    'sauce:stop'
    cb
  )





# Unit testing
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
gulp.task 'karma', (cb) ->
  runSequence 'karma:browserify', 'karma:run', cb

gulp.task 'karma:browserify', ->
  butil = require './browserify-util'
  b = butil.createBundle()

  b.add path.join(config.paths.base, 'test/unit/main.coffee')

  b.bundle()
    .pipe(source('main.js'))
    .pipe(gulp.dest('.tmp/test/unit'))

gulp.task 'karma:run', (done) ->
  karma = require('karma').server
  karma.start
    files: ['.tmp/test/unit/main.js']
    background: false
    browsers: [
      # 'Chrome'
      # 'Firefox'
      # 'Opera'
      # 'Safari'
      'PhantomJS'
    ]
    frameworks: ['jasmine']
    plugins: [
      'karma-jasmine'
      'karma-chrome-launcher'
      'karma-firefox-launcher'
      # 'karma-opera-launcher'
      'karma-safari-launcher'
      'karma-phantomjs-launcher'
      'karma-coverage'
    ]
    singleRun: true
    reporters: ['dots'] # ,'coverage'c
    coverageReporter:
      type: 'html'
      dir: 'coverage'
  , (status) ->
    if status != 0
      done new Error("Karma task has failed with status '#{status}'")
    else
      done()







# End to end testing
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
gulp.task 'protractor:setup', (cb) ->
  # Tel `start-server` task to defaultly go in standalone mode
  config.defaultServerMode = 'standalone'
  # Run API in test mode
  process.env.NODE_ENV = 'test'

  config.api.app = path.join __dirname, '..', 'test/specs/support/app-setup'
  config.api.config = _.merge config.api.config,
    express:
      session:
        type: 'memory'
    i18n:
      redisSync: false

  gutil.log gutil.colors.yellow(
    'Run `./node_modules/protractor/bin/webdriver-manager update --standalone`' +
    'if Selenium Standalone is not present.'
  )
  runSequence(
    ['sauce:start'], #, 'sass', 'browserify'
    cb
  )
gulp.task 'protractor', (cb) ->
  runSequence(
    'protractor:setup'
    'protractor:run',
    'server:stop',
    'sauce:stop'
    cb
  )

gulp.task 'protractor:run', (done) ->
  protractor = require('gulp-protractor').protractor

  getPort (err, port) ->
    return done(err) if err

    gulp.src(['test/specs/main-spec.coffee'])
      .pipe(protractor(
        configFile: path.join(config.paths.base, 'gulp/protractor-conf.coffee'),
        args: ['--baseUrl', 'http://localhost:' + port]
      ))
      .on 'error', (e) -> throw e
      .on 'end', -> done()







# Sauce labs
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

sauceConnectProcess = null
sauceUsername = process.env.SAUCE_USERNAME
sauceKey = process.env.SAUCE_ACCESS_KEY
sauceTunnelId = process.env.SAUCE_TUNNEL_ID
sauceEnabled = sauceUsername and sauceKey

sauceStart = (done) ->
  unless sauceEnabled
    gutil.log gutil.colors.red 'SauceLab is disabled.'
    done()
  else
    sauceConnectLauncher = require 'sauce-connect-launcher'
    sauceConnectLauncher(
      username: sauceUsername
      accessKey: sauceKey
      tunnelIdentifier: sauceTunnelId
    , (err, process) ->
      return done err if err
      sauceConnectProcess = process
      gutil.log gutil.colors.green 'Sauce connect listening'
      done()
    )

sauceStop = (done) ->
  if sauceConnectProcess
    sauceConnectProcess.close(done)
  else
    done()

gulp.task 'sauce:start', sauceStart
gulp.task 'sauce:stop', sauceStop







# Server
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
connectInst = null

gulp.task 'start-server-built', (done) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'

  getPort (err, port) ->
    return done(err) if err

    connectInst = connect()
      .use(serveStatic('build'))
      .listen(port)

    gutil.log 'Server listening to', gutil.colors.red('http://localhost:' + port)

    done(null)

gulp.task 'stop-server-built', (done) ->
  if connectInst
    return connectInst.close done
  done()
