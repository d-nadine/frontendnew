require 'lib/radium/show_more_mixin'

Radium.MessagesEmailPanelController = Em.ObjectController.extend
  history: (->
    return unless @get('content')
    Radium.Email.find historyFor: @get('content')
  ).property('content')

  hasNewerEmail: (->
    @get('history.firstObject') != @get('content')
  ).property('history', 'content')

  newestEmail: (->
    @get('history.firstObject')
  ).property('history')
