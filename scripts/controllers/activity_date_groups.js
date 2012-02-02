define('controllers/activity_date_groups', function(require) {
  
  var Radium = require('radium');

  Radium.activityDateGroupsController = Ember.ArrayProxy.create({
    content: [],
    // Set the filter singularly
    // @default 'day'
    dateFilter: 'day',

    days: function() {
      return this.filterProperty('type', 'day');
    }.property('@each.type').cacheable(),
    
    weeks: function() {
      return this.filterProperty('type', 'week');
    }.property('@each.type').cacheable(),

    months: function() {
      return this.filterProperty('type', 'month');
    }.property('@each.type').cacheable(),
    
    quarters: function() {
      return this.filterProperty('type', 'quarter');
    }.property('@each.type').cacheable(),

    years: function() {
      return this.filterProperty('type', 'year');
    }.property('@each.type').cacheable(),

    selectedDateType: function() {
      var selectedDateFilter = this.get('dateFilter');
      // Pluralize this here so Radium.FeedDateItemView can filter singularly
      return this.get(selectedDateFilter + 's');
    }.property('dateFilter').cacheable(),

  });

  return Radium;
});