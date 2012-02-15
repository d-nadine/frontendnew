Radium.dealsDateGroupsController = Ember.ArrayProxy.create({
  content: [],
  // Set the filter singularly
  // @default 'day'
  dateFilter: 'day',
  // Filter the feed by type
  categoryFilter: 'everything',
  userFilter: null,
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Pending', 
      shortname: 'pending', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Closed', 
      shortname: 'closed', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Paid', 
      shortname: 'paid', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Rejected', 
      shortname: 'rejected', 
      isMain: true
    })
  ],
  statsTitle: "Statistics",
  allStats: [
        ['Apple', 18385],
        ['Nokia', 12283],
        ['Microsoft', 8238],
        ['Google', 6873],
        ['Yahoo', 6612]
      ],

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