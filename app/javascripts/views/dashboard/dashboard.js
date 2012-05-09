Radium.DashboardView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'dashboard',
  selectedUserBinding: 'Radium.dashboardController.selectedUser',
  // Chart
  dashboardChart: Radium.PieChart.extend({
    title: function() {
      return (this.getPath('parentView.selectedUser')) ? this.getPath('parentView.selectedUser.firstName') + "'s Statistics" : "Your Company's Statistics"
    }.property('parentView.selectedUser'),
    seriesBinding: 'Radium.dashboardController.stats'
  }),

  // Endless scrolling properties
  feedBinding: 'Radium.dashboardFeedController',
  // targetIdBinding: 'Radium.usersController.loggedInUser.id',
  pageBinding: 'Radium.dashboardFeedController.page',
  totalPagesBinding: 'Radium.dashboardFeedController.totalPages',
  feedUrl: '/api/users/%@/feed'
});
