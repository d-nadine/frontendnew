require 'lib/radium/show_more_mixin'

Radium.MessagesEmailPanelController = Em.ObjectController.extend
  history: (->
    return unless @get('content')
    Radium.Email.find historyFor: @get('content')
  ).property('content')
