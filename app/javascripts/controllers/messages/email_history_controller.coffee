require 'lib/radium/show_more_mixin'

Radium.MessagesEmailHistoryController = Ember.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 3
