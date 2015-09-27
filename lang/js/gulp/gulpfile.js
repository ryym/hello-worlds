gulp = require('gulp')

jade = require('gulp-jade')
minify = require('gulp-minify')

gulp.task('greet', function() {
  console.log('Hello gulp');
})

gulp.task('build', function() {
  gulp.src('./*.jade')
    .pipe(jade())
    .pipe(minify())
    .pipe(gulp.dest('build/'))
})
