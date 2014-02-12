require 'lib/radium/show_more_mixin'

Radium.FeedController = Radium.ArrayController.extend
  sortProperties: ['iid']
  sortAscending: false
