require 'radium/pagination_mixin'

Radium.EmailPanelController = Em.ArrayController.extend Radium.PaginationMixin,
  contentBinding: 'inboxController.history'
  emailBinding: 'inboxController.selectedObject'
  targetBinding: Ember.Binding.oneWay 'inboxController'

  sortProperties: ['sentAt']

  perPage: 3

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length', 'email')
