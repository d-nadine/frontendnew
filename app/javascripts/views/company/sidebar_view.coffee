require 'lib/radium/combobox'
require 'lib/radium/tag_autocomplete'
requireAll /views\/sidebar/

Radium.CompanySidebarView = Radium.View.extend(Radium.ScrollableMixin)
