require "components/inline_editor_base"

Radium.InlineAutocompleteComponent = Ember.Component.extend
  focusIn: (e) ->
    @_super.apply this, arguments

    Ember.run.next =>
      @$('.editable').selectText()
