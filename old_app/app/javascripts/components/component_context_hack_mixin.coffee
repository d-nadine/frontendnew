Radium.ComponentContextHackMixin = Ember.Mixin.create
  _yield: (content, options) ->
    oldParentView = @_parentView
    unless @get('notComponentContext')
      @set '_parentView', options.data.view
      options.data.view.get('context').set '_parent', oldParentView.get('context')
    result = @_super.apply(this, arguments)
    @set '_parentView', oldParentView
    result
