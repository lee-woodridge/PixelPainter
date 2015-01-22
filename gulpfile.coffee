gulp = require "gulp"
gutil = require "gulp-util"
$ = require('gulp-load-plugins')()
express = require 'express'

gulp.task "scripts", ->
	return gulp.src('src/coffee/game.coffee', { read: false })
		.pipe($.browserify({
			transform: ['coffeeify'],
			extensions: ['.coffee']
		})).on("error", gutil.log).on("error", gutil.beep)
		.pipe($.rename('game.js'))
		.pipe(gulp.dest('./public'))
		.pipe($.livereload())

gulp.task "jade", ->
	return gulp.src("./src/jade/index.jade")
		.pipe($.jade().on("error", gutil.log).on("error", gutil.beep))
		.pipe gulp.dest("./public")
		.pipe $.livereload()

gulp.task "default", ["scripts", "jade"], ->
	app = express()
	app.use require('connect-livereload')()
	app.use express.static "#{__dirname}/public"
	$.livereload.listen()

	gutil.log gutil.colors.cyan '=== Listening on port 4001. ==='
	app.listen 4001

	gulp.watch "src/**/*.coffee", ["scripts"]
	gulp.watch "src/**/*.jade", ["jade"]
