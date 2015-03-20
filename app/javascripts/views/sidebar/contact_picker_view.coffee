require 'lib/radium/contact_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarContactPickerView = Radium.InlineEditorView.extend
  contactPicker: Radium.ContactPicker.extend Radium.ComboboxSelectMixin, Radium.InlineComboboxToggleMixin,
    classNameBindings: [':contact-picker']
    valueBinding: 'controller.form.contact'
    placeholder: 'Choose a contact'
    isSubmitted: true
    setValue: (object) ->
      @_super.apply this, arguments
      @get('controller').send 'commit'
