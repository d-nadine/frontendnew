require 'lib/radium/show_more_mixin'

Radium.EmailsHistoryController = Ember.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 3
