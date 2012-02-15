Radium.DashboardView = Ember.View.extend({
  templateName: 'dashboard',
  profileView: Radium.ProfileView,
  searchView: Radium.GlobalSearchTextView,
  usersList: Radium.UsersListView,
  // Chart
  dashboardChart: Radium.PieChart.extend({
    titleBinding: 'Radium.dashboardController.statsTitle',
    seriesBinding: 'Radium.dashboardController.stats'
  })

});