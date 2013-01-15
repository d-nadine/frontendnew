Radium.InboxView = Em.View.extend
  templateName: 'radium/inbox/inbox'

  didInsertElement: ->
    $('.email-action').dropdown()
