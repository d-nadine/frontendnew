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
        click: function() {
          
        },
        template: Ember.Handlebars.compile(userListTemplate)
      }),
      didInsertElement: function() {
        this.$().prepend('<h3>Team</h3>');
        this.$().find('tr').addClass('filter');
      }
      
    })
  });
  
  return Radium;
  
});