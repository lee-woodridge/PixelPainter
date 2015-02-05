gulp = require "gulp"
gutil = require "gulp-util"
argv = require("yargs").argv
fs = require "fs"
$ = require('gulp-load-plugins')()
express = require 'express'

gulp.task "scripts", ->
	filepath = 'src/coffee/' + argv.game + '.coffee' 
	if not fs.existsSync filepath
		console.log filepath + " doesn't exist."
		process.exit(1);
	return gulp.src(filepath, { read: false })
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

gulp.task "css", ->
	return gulp.src("src/css/*.css")
		.pipe(gulp.dest("./public"))

gulp.task "default", ["scripts", "jade", "css"], ->
	app = express()
	app.use require('connect-livereload')()
	app.use express.static "#{__dirname}/public"
	$.livereload.listen()

	gutil.log gutil.colors.cyan '=== Listening on port 4001. ==='
	app.listen 4001

	gulp.watch "src/**/*.coffee", ["scripts"]
	gulp.watch "src/**/*.jade", ["jade"]
	gulp.watch "src/**/*.css", ["css"]
