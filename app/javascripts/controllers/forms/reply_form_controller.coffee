Radium.FormsReplyController = Radium.FormsEmailController.extend
  actions:
    submit: (replyForm) ->
      @send 'sendReply', replyForm
      false

    expand: ->
      @toggleProperty 'showAddresses'
      @toggleProperty 'showSubject'
      false

    deleteFromEditor: ->
      @send 'deleteEmail', @get('model')
      false

  currentUserEmail: Ember.computed.alias 'controllers.currentUser.email'

  to: ( ->
    @get('model.to').reject (recipient) => recipient.get('email')?.toLowerCase() == @get('currentUserEmail')?.toLowerCase()
  ).property('model.to.[]')
