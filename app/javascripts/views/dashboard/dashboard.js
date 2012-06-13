Radium.DashboardView = Ember.View.extend(Radium.EndlessScrolling, {
  templateName: 'dashboard',
  selectedUserBinding: 'Radium.dashboardController.selectedUser',
  controller: Radium.dashboardFeedController
});
