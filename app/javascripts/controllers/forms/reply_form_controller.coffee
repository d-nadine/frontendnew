require 'mixins/controllers/save_email_mixin'

Radium.FormsReplyController = Radium.FormsEmailController.extend Radium.SaveEmailMixin,
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
