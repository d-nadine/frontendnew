require 'radium/limit_support'

Radium.EmailSectionController = Em.ArrayController.extend Radium.LimitSupport,
  limit: 3
  currentLimit: 3
  content: Em.A()
  hasRemainingItems: (->
    @get('remainingContent.length') > 0
  ).property('remainingContent.length')
