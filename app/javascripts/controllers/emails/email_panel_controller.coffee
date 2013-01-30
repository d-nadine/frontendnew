require 'radium/show_more_mixin'

Radium.EmailsEmailPanelController = Em.ArrayController.extend Radium.ShowMoreMixin,
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
    @get('hiddenContent.length') > 0
  ).property('hiddenContent.length', 'email')
