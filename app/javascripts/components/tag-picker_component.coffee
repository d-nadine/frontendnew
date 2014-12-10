Radium.TagPickerComponent = Ember.Component.extend
  abortResize: true

  tagsDidChange: Ember.observer 'model.tagNames.[]', ->
    # FIXME: hacky, we should bind the appropriate controller
    @get('targetObject.parentController.targetObject').send 'updateTotals'
