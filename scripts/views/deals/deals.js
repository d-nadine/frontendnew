define('views/deals/deals', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('views/profile');
  require('views/globalsearch');
  require('views/filter_list');
  require('views/feed_date_item');
  require('views/feed_date_group');
  require('views/date_filters');
  
  var template = require('text!templates/deals/deals.handlebars'),
      userListTemplate = require('text!templates/users_list.handlebars');
      
  Radium.DealPageView = Ember.View.extend({
    template: Ember.Handlebars.compile(template),
    searchView: Radium.GlobalSearchTextView,
    usersList: Ember.CollectionView.extend({
      tagName: 'ul',
      classNames: 'nav nav-tabs nav-stacked filters people'.w(),
      contentBinding: 'Radium.usersController',
      itemViewClass: Ember.View.extend({
        viewUser: function(event) {
          return false;
        },
        template: Ember.Handlebars.compile(userListTemplate)
      })
      
    }),
    // Chart
    dealsChart: Radium.PieChart.extend({
      titleBinding: 'Radium.dealsController.statsTitle',
      seriesBinding: 'Radium.dealsController.allStats'
    })
  });
  
  return Radium;
  
});