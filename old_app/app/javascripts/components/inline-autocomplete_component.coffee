Radium.InlineAutocompleteComponent = Ember.Component.extend
  classNameBindings: ['isEditing']
  focusIn: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', true

  focusOut: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', false
