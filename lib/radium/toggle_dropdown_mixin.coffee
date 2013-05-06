Radium.ToggleDropdownMixin = Ember.Mixin.create
  keyDown: (evt) ->
    return unless evt.keyCode == 40

    @get('parentView').toggleDropdown()
