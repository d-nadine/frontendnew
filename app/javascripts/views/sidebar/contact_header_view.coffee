require 'lib/radium/contact_company_picker'
require 'lib/radium/contact_company_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarContactHeaderView = Radium.InlineEditorView.extend
  isEditable: Ember.computed.alias 'controller.isEditable'
  companyPicker: Radium.ContactCompanyPicker.extend Radium.ComboboxSelectMixin,
    Radium.InlineComboboxToggleMixin,

    valueBinding: 'controller.form.company'
    companyNameBinding: 'controller.form.companyName'
    setValue: ->
      @_super.apply this, arguments
      Ember.run.next =>
        @get('parentView').toggleEditor()
