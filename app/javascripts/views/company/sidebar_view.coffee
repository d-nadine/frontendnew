require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/user_picker'
require 'lib/radium/company_picker'
require 'lib/radium/tag_autocomplete'
requireAll /views\/sidebar/

Radium.CompanySidebarView = Radium.View.extend(Radium.ScrollableMixin)
