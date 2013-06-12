require 'lib/radium/user_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarUserView = Radium.InlineEditorView.extend
  userPicker: Radium.UserPicker.extend Radium.InlineComboboxToggleMixin,
    isSubmitted: true
    leader: ''
    valueBinding: 'controller.form.user'
