Radium.DealPageView = Ember.View.extend({
  templateName: 'deals',
  searchView: Radium.GlobalSearchTextView,
  usersList: Radium.UsersListView,
  selectedUserBinding: 'Radium.dealsController.selectedUser',
  // Chart
  dealsChart: Radium.PieChart.extend({
    title: function() {
      var user = this.getPath('parentView.selectedUser');
      return (user) ? user.get('firstName') + "'s Deals" : "Deal Statistics";
    }.property('parentView.selectedUser'),
    seriesBinding: 'Radium.dealsController.dealStatistics'
  }),
  overdueDealsBinding: 'Radium.dealsController.overdueDeals'
});