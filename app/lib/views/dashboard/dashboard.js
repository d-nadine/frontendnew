Radium.DashboardView = Ember.View.extend({
  templateName: 'dashboard',
  profileView: Radium.ProfileView,
  searchView: Radium.GlobalSearchTextView,
  selectedUserBinding: 'Radium.dashboardController.selectedUser',
  // Chart
  dashboardChart: Radium.PieChart.extend({
    title: function() {
      return (this.getPath('parentView.selectedUser')) ? this.getPath('parentView.selectedUser.firstName') + "'s Statistics" : "Your Company's Statistics"
    }.property('parentView.selectedUser'),
    seriesBinding: 'Radium.dashboardController.stats'
  })

});