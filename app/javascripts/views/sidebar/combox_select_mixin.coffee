Radium.ComboboxSelectMixin = Ember.Mixin.create
  selectObject: ->
    @_super.apply this, arguments
    @get('parentView').$().trigger 'click'

  selectItem: ->
    @_super.apply this, arguments
    @get('parentView').$().trigger 'click'
