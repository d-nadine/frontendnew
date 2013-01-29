Radium.BulkEmailActionsController = Ember.ArrayController.extend
  contentBinding: 'inboxController.checkedContent'

  deleteEmails: ->
    @get('inboxController').deleteEmails()
