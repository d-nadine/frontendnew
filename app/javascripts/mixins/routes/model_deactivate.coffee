Radium.ModelDeactivateMixin = Ember.Mixin.create
  deactivate: ->
    @_super.apply this, arguments
    @controller.discardBufferedChanges() if @controller.discardBufferedChanges
    model = @get('controller').get('model')
    model.get('transaction').rollback() if model.get('isDirty')
