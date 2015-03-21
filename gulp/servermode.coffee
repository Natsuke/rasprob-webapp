gutil = require 'gulp-util'

proxifyWeborder = (done) ->
  proxy = require('http-proxy').createProxyServer()

  proxyError = (err, req) ->
    gutil.log(
      gutil.colors.red('API PROXY ERROR: ')
      gutil.colors.yellow(err.message) +
      ' for ' +
      gutil.colors.cyan(req.url) +
      '\n' + err.stack
    )

  proxy.on 'error', proxyError

  done null,
    frontend: (req, res, next) ->
      proxy.web req, res,
        target: 'http://localhost:3001'
      , next
    backend: (req, res, next) ->
      proxy.web req, res,
        target: 'http://localhost:3000'
      , next


middlifyWeborder = (done) ->
  async = require 'async'
  async.parallel
  done


module.exports = (mode, done) ->
  if mode == 'proxy'
    proxifyWeborder done
  else
    middlifyWeborder done
