Radium.DashboardFeedFilterView = Ember.View.extend
  templateName: 'radium/filters'

  filters: [
    Radium.Filters.everything
    Radium.Filters.todos
    Radium.Filters.deals
    Radium.Filters.meetings
    Radium.Filters.discussions
  ]
