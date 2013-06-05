Radium.ComboboxSelectMixin = Ember.Mixin.create
  selectValue: ->
    @_super.apply this, arguments
    @get('parentView').$().trigger 'click'

  selectItem: ->
    @_super.apply this, arguments
    @get('parentView').$().trigger 'click'
