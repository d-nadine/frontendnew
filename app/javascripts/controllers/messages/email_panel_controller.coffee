require 'lib/radium/show_more_mixin'

Radium.MessagesEmailPanelController = Ember.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 3

  activeDeal: Ember.computed.alias('sender.deals.firstObject')
  nextTask: Ember.computed.alias('sender.nextTask')

  sender: Ember.computed.alias('firstObject.sender')
