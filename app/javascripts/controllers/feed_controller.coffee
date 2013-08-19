require 'lib/radium/show_more_mixin'

Radium.FeedController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  sortAscending: false
  sortProperties: ['timestamp']

  allAreLoaded: ( ->
    notLoaded = @filterProperty('isLoaded', false).get('length')
    notLoaded == 0
  ).property('@each.isLoaded')
