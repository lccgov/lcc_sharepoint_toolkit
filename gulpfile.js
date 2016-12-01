var gulp = require('gulp');
var jshint = require('gulp-jshint');
var jasmine = require('gulp-jasmine');

var paths = {
  source: {scripts: './javascript/**/*.js'}
};

gulp.task('lint', function() {
  return gulp.src(paths.source.scripts)
    .pipe(jshint())
    .pipe(jshint.reporter('default'))
});

gulp.task('test', function () {
  return gulp.src('./spec/*.js')
        .pipe(jasmine())
});

gulp.task('default', ['lint', 'test']);