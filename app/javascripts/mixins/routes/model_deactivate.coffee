Radium.ModelDeactivateMixin = Ember.Mixin.create
  deactivate: ->
    @_super.apply this, arguments
    @controller.discardBufferedChanges() if @controller.discardBufferedChanges
    model = @controller.get('model')
    model.get('transaction').rollback() if model.get('isDirty')
