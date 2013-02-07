Radium.EmailItemController = Em.ObjectController.extend
  showActions: false
  showReply: false

  showActionSection: ->
    @toggleProperty 'showActions'

  showReplySection: ->
    @toggleProperty 'showReply'
