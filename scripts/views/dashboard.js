define('views/dashboard', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('views/profile');
  require('views/globalsearch');
  require('views/filter_list');
  require('views/feed_date_item');
  require('views/feed_date_group');
  require('views/date_filters');
  require('views/dashboard/announcements');
  
  var template = require('text!templates/dashboard.handlebars'),
      userListTemplate = require('text!templates/users_list.handlebars');
      
  Radium.DashboardView = Ember.View.extend({
    template: Ember.Handlebars.compile(template),
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
        template: Ember.Handlebars.compile(userListTemplate)
      })
      
    }),

    didInsertElement: function() {
      // Charts
      var chart;
      chart = new Highcharts.Chart({
        chart: {
          renderTo: 'feed-chart',
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
        },
        title: {
          text: 'Campaign Progress'
        },
        tooltip: {
          formatter: function() {
            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
          }
        },
        plotOptions: {
          pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
              enabled: true,
              formatter: function() {
                return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
              }
            }
          }
        },
        series: [{
          type: 'pie',
          name: 'Browser share',
          data: [
            ['MacPro',   45.0],
            ['iPhone',       26.8],
              {
                name: 'iMacs',
                y: 12.8,
                sliced: true,
                selected: true
              },
            ['Macbook Airs',    8.5],
            ['Monitor',     6.2],
            ['iPod',   0.7]
          ]
        }]
      });
    }
  });
  
  return Radium;
  
});