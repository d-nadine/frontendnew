Radium.MessagesReplyController = Em.ObjectController.extend
  reply: null
  init: ->
    @_super.apply this, arguments
    @reset()

  isValid: (->
    @get 'isMessageValid'
  ).property('isMessageValid')

  isMessageValid: (->
    !Ember.isEmpty @get('reply.message')
  ).property('description')

  submit: ->
    return unless @get('isValid')
    @set('reply.subject', "RE: #{@get('model.subject')}")
    Radium.Utils.notify('Reply Sent!')
    # FIXME: commit to store
    # @get('model').commit()
    @reset()
    @set('target.showReply', false)

  reset: ->
    @set 'reply', Radium.Email.createRecord()
