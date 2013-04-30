Radium.FormsReplyController = Radium.FormsEmailController.extend
  submit: (replyForm) ->
    @send 'sendReply', replyForm

  expand: ->
    @toggleProperty 'showAddresses', true
    @toggleProperty 'showSubject', true
