# Radium

## Bootstrapping

1. Install node (this is needed for compiling)
2. Install casperjs (this can be done with homebrew)
3. Install ruby 1.9.3
4. bundle
5. `cd new-test`
6. `npm install`
7. `bower install`

## Developing

Developing happens using Iridium's preview server. You can start the
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

Tests are written with qunit and, currently, Iridium must be running to execute them.

This is a bit awkward for now, but you need 3 terminal windows for tests to run: 1 for Iridium (this compiles changes to your JS and CSS), 1 for Karma test runner, and 1 for initiating tests.

Window 1: `bundle exec iridium server`
Window 2: `karma start`
Window 3: `karma run`

There are old tests in the `test/` directory that don't run, for now the only working tests are in the `new-test/` directory.

A basic style guide listing common UI components and the markup required to generate them is available. Right now it runs off the generated Sass/Compass outputted to the `site` directory. To view, simply open the `index.html` file in `test/styles/index.html`.

## Deploying

Deploying is easy: `$ ./script/deploy`. This will do some integrity
checks and finally push the code upstream.

# Conventions & Rules

## Directory Structure

The code is organized into 4 main directories: `app`, `lib`, `test`,
`vendor`. Different types of code go into different places.

* `app`: Application specific code: models, views, controllers,
  templates
* `lib`: Framework level code, or code that can be reused outside the
  application
* `test`: For tests bro.
* `vendor`: Code written by other people. Can be CSS, JS, or other
  assets

The `app` directory is strictly organized. It is this way to handle
the large number of classes and files. Ember apps' require a lot of
classes. Each class has it's own file. All the code lives inside
`app/javascripts`. That directory is also organized by responsiblity.

* `adapters`: All the files to connect the store to various backends.
* `controllers`: All the controllers.
* `factories`: Model factories defined in this directory.
* `helpers`: Bound and unbound helpers for Handlebars templates
* `mixins`: Reusable modules. Loosely organized.
* `models`: All sorts of models. Not just `DS.Store` models. These may
  also be domain models
* `views`: Views only. There are a lot. There are subfolders for
  different pages and responsibilities.

## Rules

1. These types of files must include their responsiblity in the class
   name and file name: **Views, Controllers, Helpers, Adapters, and
   Serializers**. EX: `DashboardController` and
   `dashboard_controller.coffee`
2. View subtypes **must** also include their responsiblity in the name.
   Example: `MeetingFormView.coffee` and `view/forms/meeting_form.coffee`.
3. Views **must** be placed into a subfolder for the page they're used
   on. Example: `views/dashboard`, `views/calendar`.
4. Reusable views **must** be placed into `views/shared`.
5. A View's class name **should** match to a file in `templates/`.
   This makes automatica `templateName` lookup possible. EX:
   `DashboardView` becomes `templates/dashboard_view`.
6. Tests must end in `_test`
7. Test directory structure should mirror `app` and `lib`.
8. Follow this [CoffeeScript Style Guide](https://github.com/polarmobile/coffeescript-style-guide)
9. Exception to #8: Prefer `||=` over `or=`
10. New code **must** follow these rules. Old code should be updated.
11. `Ember.CollectionView` subclasses **should** contain "List" in the
    name.

# Code design

## Feed design

Feed is divided into feed sections which represent specific days. By default
feed is just a list of `Radium.FeedSection` models, which contain feed items,
which are implemented with `Radium.ExtendedRecordArray`. Extended record array
is really similar to regular record array, with the small difference in data
that it can held - instead of keeping client ids internally, it keeps pairs of
record type and client id. This allows to keep multiple type of records in such
array.

If there is more items of the same type, they are collected into clusters.
Clustering is added with `Radium.ClusteredRecordArray` mixin, which adds 2
attributes to an array: `clusters` and `unclustered`. You can still iterate
through the array with `section.get('items').forEach`, but if you want to use
clusters, you have those additional attributes to deal with it.

The most important view for displaying feed is `Radium.FeedSectionsListView`.
It displays individual sections and manages things like scroll adjustments (for
example if items are added on top of the feed, it will adjust `scrollTop` value
to make scrolling smooth and avoid jumps). It also manages inserting "gap
views". If user filters feed and additional feed sections are loaded, we show
the information that additional feed items are loaded, but they're filtered.

Feed sections number is by default limited to whatever is set in
`controller.itemsLimit`, which by default is 30. This is done to not make app
slow if user scrolls a lot. At some point in time, the limit could be changed
to something bigger, but without optimization in the app or optimizations in
ember, it's safe value to not make site really slow.

Individual section is just a list of items handled by
`Radium.FeedItemsListView`. The only not so usual thing is that it uses
container (`Radium.FeedItemContainerView`) as `itemViewClass`. This is needed,
because feed item may be any of several types of items, like Todo, Meeting etc

## Filtering

Filtering is done with `FilteredCollectionMixin`, which uses `Filterable` mixin
underneath and filters items based on a setting in controller.

## Calendar feed

I designed calendar feed to behave just like regular feed, but with specific
filter displayed by default and `disableClusters` set by default.

## Ranges

Users can group sections in to ranges - you can display feed in daily, weekly
and monthly chunks. This is implemented as an array which is basically proxy
over several feed sections. So for example if you want to display weekly range,
it will group 7 feed sections and will combine all the items from those 7
sections into one collection. Class that's used for this is
`Radium.GroupedFeedSection`. Although it's a model, I didn't assume that it
will be fetched from server - it's just because I wanted to cache created
records easier. I'm not sure if this is a good idea at the moment - depending
on future direction that application will be going, maybe it will be better to
change the impplementation to use ad-hoc class that will be destroyed when not
used. This may be better approach if for example grouped feed sections start
taking too much memory.

## Notifications center

Notifications center is pretty straightforward thing - it just displays list of
active notifications and takes you to a view of given item when notification
for it was clicked.
