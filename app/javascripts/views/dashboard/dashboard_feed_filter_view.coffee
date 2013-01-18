require 'radium/views/sidebar_view'

Radium.DashboardFeedFilterView = Radium.SidebarView.extend
  templateName: 'radium/filters'

  filters: [
    Radium.Filters.everything
    Radium.Filters.todos
    Radium.Filters.deals
    Radium.Filters.meetings
  ]
