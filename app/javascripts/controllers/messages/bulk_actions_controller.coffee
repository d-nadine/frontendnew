Radium.MessagesBulkActionsController = Ember.ArrayController.extend
  itemController: 'messagesBulkActionItem'
  activeForm: null

  cancelAll: ->
    # FIXME: No idea why this did not work if toArray was not used
    @get('model').toArray().forEach (item) ->
      item.set('isChecked', false)

  bulkFormOpen: (activeForm) ->
    @set('activeForm', activeForm)

  bulkFormClosed: ->
    @set('activeForm', null)
