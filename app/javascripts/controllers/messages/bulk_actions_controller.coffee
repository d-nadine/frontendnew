Radium.MessagesBulkActionsController = Ember.ArrayController.extend
  needs: ['messages']
  modelBinding: 'controllers.messages.checkedContent'

  cancelAll: ->
    # FIXME: No idea why this did not work if toArray was not used
    @get('model').toArray().forEach (item) ->
      item.set('isChecked', false)
