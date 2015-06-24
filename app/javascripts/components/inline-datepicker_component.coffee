require 'mixins/inline_editor_behaviour'
require 'mixins/inline_save_editor'

Radium.InlineDatepickerComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  Radium.InlineSaveEditor,
  classNameBindings: [':date-picker']
