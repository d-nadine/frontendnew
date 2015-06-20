require "components/inline_editor_base"

Radium.InlineEditorComponent = Radium.InlineEditorBase.extend
  classNameBindings: ['isEditing']
  focusIn: (e) ->
    @set 'isEditing', true

   focusOut: (e) ->
    @set 'isEditing', false

  isEditing: false
