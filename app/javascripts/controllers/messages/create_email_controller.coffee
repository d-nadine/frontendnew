Radium.MessagesCreateEmailController = Em.ObjectController.extend
  needs: ['messages']

  cancel: ->
    @get('controllers.messages').set 'createEmail', false
