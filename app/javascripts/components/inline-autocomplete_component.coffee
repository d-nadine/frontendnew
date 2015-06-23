require "components/inline_editor_base"

Radium.InlineAutocompleteComponent = Ember.Component.extend
  classNameBindings: ['isEditing']
  focusIn: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', true

    Ember.run.next =>
      @$('.editable').selectText()

  focusOut: (e) ->
    @_super.apply this, arguments

    @set 'isEditing', false
