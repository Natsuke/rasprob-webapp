config = require './config'
gulp = require 'gulp'

gutil = require 'gulp-util'

getPort = require 'getport'
async = require 'async'
lrPort = async.memoize(getPort).bind(null, 35729)




# start the live reload server
livereloadServer = (done) ->
  tinyLr = require 'tiny-lr'
  lr = null

  lrPort (err, port) ->
    return done(err) if err

    lr = tinyLr()
    lr.listen port, done

    # reload static files when changed
  gulp.watch config.paths.livereload, (file) ->
    lr.changed
      body:
        files: [
          file.path
            .replace("#{config.paths.base}/.tmp/", '')
        ]

gulp.task 'livereload', livereloadServer





# Server
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

gulp.task 'test-server', (done) ->
  require('run-sequence')(
    'server:start', 'server:stop'
    done
  )

[server, httpServer] = []

serverStart = (options, done) ->
  connect = require 'connect'
  livereload = require 'connect-livereload'
  logger = require 'connect-logger'
  serveStatic = require 'serve-static'
  connectDisable304 = require 'connect-disable-304'
  servermode = require './servermode'
  args = require('yargs')
          .defaults('mode', '')
          .argv
  mode = args.mode || config.defaultServerMode

  _ = require 'lodash'

  options = _.merge
    staticDirs: ['.tmp', 'app']
  , options

  async.parallel
    port: lrPort
    servermode: servermode.bind null, mode
    webport: getPort.bind null, config.www.port
  , (err, res) ->
    return done err if err

    server = connect()
      .use('/api', res.servermode.frontend)
      .use('/backend', res.servermode.backend)
      .use(logger())
      .use(livereload(
        port: res.port
      ))
      .use('/cordova.js', (req, res) ->
        res.setHeader 'Content-Type', 'application/javascript'
        res.end '(function(){})();'
      )
      .use(connectDisable304())

    options.staticDirs.forEach (p) ->
      server.use serveStatic(p)

    server.__api__ = res.servermode.api
    gutil.log 'Server listening to', gutil.colors.red('http://localhost:' + res.webport)

    httpServer = server.listen(res.webport, done)

serverStop = (done) ->
  if server?.__api__?
    server.__api__.stop (err) ->
      return done err if err
      httpServer.close done
  else if httpServer
    httpServer.close done
  else
    done()

gulp.task 'server:start', serverStart.bind null, {}
gulp.task 'server:build:start', serverStart.bind null,
  staticDirs: ['build']
gulp.task 'server:stop', serverStop
