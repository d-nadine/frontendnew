Radium.ToggleDropdownMixin = Ember.Mixin.create
  keyDown: (evt) ->
    @_super.apply this, arguments unless evt.keyCode == 40

    @get('parentView').toggleDropdown()
