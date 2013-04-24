Radium.MessagesCreateEmailController = Radium.ObjectController.extend
  needs: ['messages']

  cancel: ->
    @get('controllers.messages').set 'createEmail', false
