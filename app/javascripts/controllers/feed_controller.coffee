require 'lib/radium/show_more_mixin'

Radium.FeedController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  sortProperties: ['id']
  sortAscending: false
