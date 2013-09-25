Radium.FormsReplyController = Radium.FormsEmailController.extend
  actions:
    submit: (replyForm) ->
      @send 'sendReply', replyForm

    expand: ->
      @toggleProperty 'showAddresses'
      @toggleProperty 'showSubject'
