path = require 'path'

module.exports =
  www:
    port: 8080
  paths:
    base: path.join(__dirname, '..')
    app: 'app'
    tmp: '.tmp'
    styles:
      all: 'app/styles/**/*.{sass,scss}'
      tmp: '.tmp/styles'
    scripts:
      main: 'app/scripts/main.coffee'
      all: 'app/scripts/**/*.coffee'
      tmp: '.tmp/scripts'
    copy:
      'app/images/**/*': 'build/images'
      'app/styles/fonts/**/*': 'build/styles/fonts'
      'app/styles/iconfont/**/*': 'build/styles/iconfont'
      'app/bower_components/ionic/release/fonts/**':
        'build/bower_components/ionic/release/fonts'
    livereload: [
      '.tmp/styles/*.css'
      '.tmp/scripts/*.js'
    ]
  sassConfig:
    imagePath: '../images'
    includePaths: ['node_modules']
  frontend:
    apiUrl: '/api'
