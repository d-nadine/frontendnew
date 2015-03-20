require 'views/leads/lead_sources_view'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarAssignedToView = Radium.InlineEditorView.extend
  leadSources: Radium.LeadSourcesView.extend Radium.InlineComboboxToggleMixin,
    valueBinding: 'controller.form.source'
