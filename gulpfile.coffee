gulp = require 'gulp'

require './gulp/tasks-scripts'
require './gulp/tasks-styles'
require './gulp/tasks-server'
require './gulp/tasks-test'
require './gulp/tasks-symbols'
require './gulp/tasks-build'


gulp.task 'serve', [
  # Styles
  'sass'
  'sass:watch'

  # Scripts
  'lint'
  'lint:watch'
  'browserify:watch:spawn'

  # Server
  'server:start'
  'livereload'
]
