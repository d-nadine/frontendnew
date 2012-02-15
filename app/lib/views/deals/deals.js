minispade.require('radium/templates/deals/deals'),
minispade.require('radium/templates/users_list');
    
Radium.DealPageView = Ember.View.extend({
  templateName: 'deals',
  searchView: Radium.GlobalSearchTextView,
  usersList: Radium.UsersListView,
  // Chart
  dealsChart: Radium.PieChart.extend({
    titleBinding: 'Radium.dealsDateGroupsController.statsTitle',
    seriesBinding: 'Radium.dealsDateGroupsController.allStats'
  }),
  overdueDealsBinding: 'Radium.dealsController.overdueDeals'
});