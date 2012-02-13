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

  // FIXME: Look into using a binding transform here instead of replacing
  selectedDay: function() {
    var dateStr = this.get('dateFilter');
    return this.filterProperty('date', dateStr);
  }.property('dateFilter').cacheable(),

  selectedDateType: function() {
    var selectedDateFilter = this.get('dateFilter');
    if (selectedDateFilter.match('-')) {
      return this.get('selectedDay');
    } else {
      // Pluralize this here so Radium.FeedDateItemView can filter singularly
      return this.get(selectedDateFilter + 's');
    }
  }.property('dateFilter').cacheable()

});