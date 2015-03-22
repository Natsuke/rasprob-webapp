
window.$ = window.jQuery = require 'jquery'

require('angular')
require('angular-animate')
require('angular-sanitize')
require('angular-ui-router')
window.moment = require('moment')
require('angular-moment')
require('ionic')
require('ionic/release/js/ionic-angular')
require('videojs')

app = angular.module 'web-app', [
  'ionic',
  'ui.router',
  'angularMoment'
]

# Services

app.service 'rasprobUrl', require './services/rasprob-url'

require './constants'
require './app/states'
