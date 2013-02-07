Radium.MessagesReplyView = Em.View.extend
  replyTextArea: Ember.TextArea.extend(Radium.TextAreaMixin,
    placeHolder: 'reply'
    classNames: ['reply']
    target: 'controller'
    action: 'submit'
    valueBinding: 'controller.reply.message'

    didInsertElement: ->
      @_super.apply this, arguments
      @$().focus()
  )
