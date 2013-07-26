require 'lib/radium/user_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarContactPickerView = Radium.InlineEditorView.extend
  contactPicker: Radium.Combobox.extend Radium.ComboboxSelectMixin, Radium.InlineComboboxToggleMixin,
    classNameBindings: [':contact-picker']
    # sourceBinding: 'controller.controllers.contacts'
    valueBinding: 'controller.form.contact'
    placeholder: 'Choose a contact'
    isSubmitted: true
