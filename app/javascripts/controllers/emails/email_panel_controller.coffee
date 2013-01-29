require 'radium/pagination_mixin'

Radium.EmailPanelController = Em.ArrayController.extend Radium.PaginationMixin,
  needs: ['emails']

  contentBinding: 'emailsController.history'
  emailBinding: 'emailsController.selectedContent'
  targetBinding: Ember.Binding.oneWay 'emailController'

  sortProperties: ['sentAt']

  perPage: 3

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length', 'email')
