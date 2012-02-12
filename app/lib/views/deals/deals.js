minispade.require('radium/templates/deals/deals'),
minispade.require('radium/templates/users_list');
    
Radium.DealPageView = Ember.View.extend({
  templateName: 'deals',
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
  dealsChart: Radium.PieChart.extend({
    titleBinding: 'Radium.dealsController.statsTitle',
    seriesBinding: 'Radium.dealsController.allStats'
  })
});