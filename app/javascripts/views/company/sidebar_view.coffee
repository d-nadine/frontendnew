require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/user_picker'
require 'lib/radium/company_picker'
require 'lib/radium/tag_autocomplete'
require 'views/contact/contact_view_mixin'
requireAll /views\/sidebar/

Radium.CompanySidebarView = Radium.View.extend  Radium.ContactViewMixin,
  companyInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.name'

  userInlineEditor: Radium.UserInlineEditor.extend()
