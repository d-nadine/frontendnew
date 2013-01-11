require 'radium/pagination_support'

Radium.EmailSectionController = Em.ArrayController.extend Radium.PaginationMixin,
  sortProperties: ['sentAt']

  perPage: 3

  content: Em.A()

  mostRecentEmailBinding: 'firstObject'

  hasPreviousEmails: (->
    @get('firstObject') != @get('email')
  ).property('firstObject', 'email')

  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length')
