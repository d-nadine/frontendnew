# hacky need to use controller of the table component for certain functions
Radium.ContainingControllerMixin = Ember.Mixin.create
  containingController: Ember.computed ->
    if parent = @get('parent')
      parent
    else
      @get('targetObject.table.targetObject')
