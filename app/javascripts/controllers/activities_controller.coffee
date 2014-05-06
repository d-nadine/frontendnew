Radium.ActivitiesController = Radium.ArrayController.extend
  itemController: 'activityItem'

  activities: Ember.computed.filter '@this', (item) ->
    item.get('isLoaded') && !item.get('isDeleted')

Radium.ActivityItemController = Radium.ObjectController.extend
  actions:
    saveNote: (note)->
      note.one "becameError", (result)=>
        @send "flashError", "encountered an error while trying to save your note"
        result.reset()

      note.one 'becameInvalid', (result) =>
        @send 'flashError', result
        result.reset()

      @get('store').commit()
