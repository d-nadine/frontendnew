require 'lib/radium/show_more_mixin'

Radium.MessagesEmailPanelController =Ember.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 3
