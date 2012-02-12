minispade.require('text!templates/dashboard');
minispade.require('text!templates/users_list');
    
Radium.DashboardView = Ember.View.extend({
  templateName: 'dashboard',
  profileView: Radium.ProfileView,
  searchView: Radium.GlobalSearchTextView,
  usersList: Ember.CollectionView.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked filters people'.w(),
    contentBinding: 'Radium.usersController',
    itemViewClass: Ember.View.extend({
      viewUser: function(event) {
        return false;
      },
      templateName: 'users_list'
    })
    
  }),

  // Chart
  dashboardChart: Radium.PieChart.extend({
    titleBinding: 'Radium.dashboardController.statsTitle',
    seriesBinding: 'Radium.dashboardController.allStats'
  })

});