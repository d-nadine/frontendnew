require 'radium/pagination_mixin'

Radium.EmailPanelController = Em.ArrayController.extend Radium.ShowMoreMixin,
  contentBinding: 'inboxController.history'
  emailBinding: 'inboxController.selectedContent'
  targetBinding: Ember.Binding.oneWay 'inboxController'

  sortProperties: ['sentAt']

  perPage: 3

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('hiddenContent.length') > 0
  ).property('hiddenContent.length', 'email')
