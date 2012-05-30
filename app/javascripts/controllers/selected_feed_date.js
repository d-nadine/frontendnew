Radium.selectedFeedDateController = Ember.ArrayProxy.extend({
  content: [],
  todos: function() {
    return this.filterProperty('type', 'todo').getEach('referenceID').uniq();
  }.property('@each.type').cacheable(),
  meetings: function() {
    return this.filterProperty('type', 'meeting');
  }.property('@each.type').cacheable(),
  deals: function() {
    return this.filterProperty('type', 'deal');
  }.property('@each.type').cacheable(),
  messages: function() {
    return this.filterProperty('type', 'message');
  }.property('@each.type').cacheable(),
  phonecalls: function() {
    return this.filterProperty('type', 'calllist');
  }.property('@each.type').cacheable(),
  discussions: function() {
    return this.filterProperty('type', 'calllist');
  }.property('@each.type').cacheable(),
  pipeline: function() {
    return this.filterProperty('type', 'calllist');
  }.property('@each.type').cacheable(),
  // Cache all the different activity types
  activityTypes: function() {
    return this.mapProperty('type').uniq();
  }.property('@each.type').cacheable()
});
