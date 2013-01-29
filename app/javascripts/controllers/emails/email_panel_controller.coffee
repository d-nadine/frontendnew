require 'radium/pagination_mixin'

Radium.EmailsEmailPanelController = Em.ArrayController.extend Radium.PaginationMixin,
  needs: ['emails']

  contentBinding: Ember.Binding.oneWay 'controllers.emails.history'
  emailBinding: Ember.Binding.oneWay 'controllers.emails.selectedContent'

  sortProperties: ['sentAt']

  perPage: 3

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length', 'email')
