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

  selectedDateType: function() {
    var selectedDateFilter = this.get('dateFilter');
    if (selectedDateFilter.match('-')) {
      return this.get('selectedDay');
    } else {
      // Pluralize this here so Radium.FeedDateItemView can filter singularly
      return this.get(selectedDateFilter + 's');
    }
  }.property('@each.updatedAt', 'dateFilter').cacheable(),
  
  displaySpecificDate: function(manager, context) {
    var activity = Radium.store.filter(Radium.Activity, function(data) {
      var testString = data.updated_at;
      if (testString.match(/\d+-\d+-\d+/)[0] === context) return true;
    });
    Radium.activitiesController.set('content', activity);
    Radium.activitiesController.set('dateFilter', context);
    manager.goToState('specificDate');
  }
});