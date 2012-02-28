Radium.feedController = Ember.ArrayProxy.extend({
  selectedUser: null,
  selectedDate: 'day',
  dateFilter: 'day',
  days: function() {
    return this.mapProperty('day').uniq();
  }.property('@each.updatedAt').cacheable(),
  
  weeks: function() {
    return this.mapProperty('week').uniq();
  }.property('@each.updatedAt').cacheable(),

  months: function() {
    return this.mapProperty('month').uniq();
  }.property('@each.updatedAt').cacheable(),
  
  quarters: function() {
    return this.mapProperty('quarter').uniq();
  }.property('@each.updatedAt').cacheable(),

  years: function() {
    return this.mapProperty('year').uniq();
  }.property('@each.updatedAt').cacheable(),

  // 
  selectedDateType: function() {
    var selectedDateFilter = this.get('dateFilter');
    // Test for a date string, and if so fetch that locally
    if (selectedDateFilter.match('-')) {
      return false;
    } else {
      // Pluralize this here so Radium.FeedDateItemView can filter singularly
      return this.get(selectedDateFilter + 's');
    }
  }.property('@each.updatedAt', 'dateFilter').cacheable()
});