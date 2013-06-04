require 'lib/radium/contact_company_picker'

Radium.SidebarContactHeaderView = Radium.InlineEditorView.extend
  isEditable: Ember.computed.alias 'controller.isEditable'
  companyPicker: Radium.ContactCompanyPicker.extend Radium.ComboboxSelectMixin,
    valueBinding: 'controller.form.company'
    companyNameBinding: 'controller.form.companyName'
