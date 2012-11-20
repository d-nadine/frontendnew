# Radium

## Bootstrapping

1. Install node (this is needed for compiling)
2. Install casperjs (this can be done with homebrew)
3. Install ruby 1.9.3
4. bundle

## Developing

Developing happens using Iridium's preview server. You can stat the
server by running: `bundle exec iridium server` then opening the URL
in your browser. Edit your files and hit refresh.

## Working with Custom Ember or Ember-Data

It's highly likely that you'll need to modify both of these libraries.
There are rake tasks to make this process easy. Clone ember into
`vendor/ember.js`. Clone ember-data into `vendor/data`. These two
directories are listed on gitignore because the source is needed. You
can run `rake build` to generate the distributed files. The
distributed files are copied into `vendor/javascripts` so they are
compiled with the app. The production builds are used. They have all
the optimizations except they are minimized. This makes it possible to
debug code in the running app. You can symlink `vendor/ember.js` or
`vendor/data` to other locations on the file system.

## Testing

Tests are written with qunit and executed with Iridium. You can run
all tests: `$ bundle exec iridium test`

## Deploying

Deploying is easy: `$ ./script/deploy`. This will do some integrity
checks and finally push the code upstream.
