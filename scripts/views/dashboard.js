define('views/dashboard', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('views/profile');
  require('views/globalsearch');
  require('views/filter_list');
  
  var template = require('text!templates/dashboard.handlebars'),
      userListTemplate = require('text!templates/users_list.handlebars');
      
  Radium.DashboardView = Ember.View.extend({
    template: Ember.Handlebars.compile(template),
    profileView: Radium.ProfileView,
    searchView: Radium.GlobalSearchTextView,
    usersList: Ember.CollectionView.extend({
      tagName: 'table',
      classNames: 'filters people'.w(),
      contentBinding: 'Radium.usersController',
      itemViewClass: Ember.View.extend({
        click: function() {
          
        },
        template: Ember.Handlebars.compile(userListTemplate)
      }),
      didInsertElement: function() {
        this.$().prepend('<thead><tr id="secondary-filter"><th colspan="3">People</th></tr></thead>');
        this.$().find('tr').addClass('filter');
      }
      
    })
  });
  
  return Radium;
  
});