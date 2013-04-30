require 'lib/radium/show_more_mixin'

Radium.EmailsHistoryController = Ember.ArrayController.extend Radium.ShowMoreMixin,
  sortProperties: ['sentAt']
  sortAscending: false
  perPage: 3
