require 'lib/radium/user_picker'
require 'lib/radium/contact_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarContactPickerView = Radium.InlineEditorView.extend
  contactPicker: Radium.ContactPicker.extend Radium.ComboboxSelectMixin, Radium.InlineComboboxToggleMixin,
    classNameBindings: [':contact-picker']
    valueBinding: 'controller.form.contact'
    placeholder: 'Choose a contact'
    isSubmitted: true
