config = require './config'
gulp = require 'gulp'


gulp.task 'sass', ->
  sass = require 'gulp-sass'
  importCSS = require 'gulp-import-css'
  plumber = require 'gulp-plumber'
  autoprefixer = require 'gulp-autoprefixer'

  gulp.src(config.paths.styles.all)
    .pipe(plumber())
    .pipe(sass(config.sassConfig))
    .pipe(importCSS())
    .pipe(autoprefixer(
        browsers: ['last 2 versions']
    ))
    .pipe(gulp.dest(config.paths.styles.tmp))

gulp.task 'sass:watch', ->
  gulp.watch config.paths.styles.all, ['sass']
