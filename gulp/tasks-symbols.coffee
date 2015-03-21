path = require 'path'
_ = require 'lodash'

gulp = require 'gulp'
runSequence = require 'run-sequence'
gutil = require 'gulp-util'

# Config
sketchFile = 'design_assets/symbol-font.sketch'

fontName = 'weborder-icon-font'
className = 'weborder-icon'

template = 'fontawesome-style'
distFontPath = 'app/styles/iconfont'
fontPath = 'iconfont/fonts/'

sampleFontPath = 'fonts/'
templateCSS = 'design_assets/symbol_templates/template.css'
templateHTML = 'design_assets/symbol_templates/template.html'

# Task
gulp.task 'symbols', -> runSequence 'do-symbols', 'sass'

gulp.task 'watch-symbols', ->
  gulp.watch(sketchFile, debounceDelay: 3000, ['symbols'])

gulp.task 'do-symbols', ->
  rename = require 'gulp-rename'
  sketch = require 'gulp-sketch'
  iconfont = require 'gulp-iconfont'
  consolidate = require 'gulp-consolidate'

  # TODO: Warning if error
  gutil.log gutil.colors.yellow(
    'Warning: sketchtool needed. Please install http://bohemiancoding.com/sketch/tool/'
  )

  gulp.src(sketchFile)
    .pipe(sketch(
      export: 'artboards'
      formats: 'svg'
    ))
    .pipe(iconfont(fontName: fontName))
    .on('codepoints', (codepoints) ->
      options =
        glyphs: codepoints
        fontName: fontName
        fontPath: fontPath
        className: className

      gulp.src(templateCSS)
        .pipe(consolidate('lodash', options))
        .pipe(rename(basename: fontName))
        .pipe(gulp.dest(path.join(distFontPath, 'css')))

      htmlOptions = _.merge {}, options
      htmlOptions.fontPath = sampleFontPath

      gulp.src(templateHTML)
        .pipe(consolidate('lodash', htmlOptions))
        .pipe(rename(basename: 'sample'))
        .pipe(gulp.dest(distFontPath))
    )
    .pipe(gulp.dest(path.join(distFontPath, 'fonts')))
