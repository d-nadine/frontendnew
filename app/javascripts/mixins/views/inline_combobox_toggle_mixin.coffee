Radium.InlineComboboxToggleMixin = Ember.Mixin.create
  setValue: ->
    @_super.apply this, arguments
    Ember.run.next =>
      @get('parentView').toggleEditor()

  selectItem: ->
    @_super.apply this, arguments
    Ember.run.next =>
      @get('parentView').toggleEditor()
