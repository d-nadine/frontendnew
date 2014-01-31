Radium.ToggleDropdownMixin = Ember.Mixin.create
  keyDown: (evt) ->
    return unless evt.keyCode == 40

    parentView = @get('parentView')
    parentView.toggleDropdown() if parentView.toggleDropdown
