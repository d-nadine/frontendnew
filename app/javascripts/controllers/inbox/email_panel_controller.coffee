require 'radium/pagination_mixin'

Radium.EmailPanelController = Em.ArrayController.extend Radium.PaginationMixin,
  contentBinding: 'inboxController.history'
  emailBinding: 'incboxController.active'

  sortProperties: ['sentAt']

  perPage: 3

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length', 'email')

  deleteEmail: (event) ->
    email = event.context

    Radium.get('router.inboxController').deleteEmail(email)

  setVisibility: (event) ->
    email = event.context

    email.toggleProperty('isPublic')

    #FIXME: commit change


