Radium.activitiesController = Radium.feedController.create({
  content: [],
  // Filter the feed by type
  categoryFilter: 'everything',
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Todos', 
      shortname: 'todo', 
      formViewClass: 'Todo',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Meetings', 
      shortname: 'meeting', 
      formViewClass: 'Meeting',
      isMain: false
    }), 
    Ember.Object.create({
      title: 'Phone Calls', 
      shortname: 'phonecall', 
      formViewClass: 'CallList',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Deals', 
      shortname: 'deal', 
      formViewClass: 'Deal',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Messages', 
      shortname: 'message',
      formViewClass: 'Message', 
      isMain: false
    }),
    Ember.Object.create({
      title: 'Discussions', 
      shortname: 'discussion', 
      formViewClass: 'Discussion',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Pipeline', 
      shortname: 'pipeline', 
      isMain: true
    })
  ],
  // todos: function() {
  //   return this.filterProperty('type', 'todo');
  // }.property('@each.type').cacheable(),
  // meetings: function() {
  //   return this.filterProperty('type', 'meeting');
  // }.property('@each.type').cacheable(),
  // deals: function() {
  //   return this.filterProperty('type', 'deal');
  // }.property('@each.type').cacheable(),
  // messages: function() {
  //   return this.filterProperty('type', 'message');
  // }.property('@each.type').cacheable(),
  // phonecalls: function() {
  //   return this.filterProperty('type', 'calllist');
  // }.property('@each.type').cacheable(),
  // discussions: function() {
  //   return this.filterProperty('type', 'calllist');
  // }.property('@each.type').cacheable(),
  // pipeline: function() {
  //   return this.filterProperty('type', 'calllist');
  // }.property('@each.type').cacheable(),

  // Cache all the different activity types
  activityTypes: function() {
    return this.mapProperty('type').uniq();
  }.property('@each.type').cacheable()
});