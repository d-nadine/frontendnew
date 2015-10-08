Radium.RemoveAllNewOnDeactivate = Ember.Mixin.create
  deactivate: ->
    @controller.get('model').filter((a) -> a.get('isNew'))
                            .forEach (a) -> a.unloadRecord()
