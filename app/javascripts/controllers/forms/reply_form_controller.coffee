Radium.FormsReplyController = Radium.FormsEmailController.extend
  actions:
    submit: (replyForm) ->
      @send 'sendReply', replyForm
      false

    expand: ->
      @toggleProperty 'showAddresses'
      @toggleProperty 'showSubject'
      false

    cancelCreate: ->
      @send 'deleteEmail', @get('model')
      false
