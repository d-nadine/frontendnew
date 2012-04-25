Radium.FeedGroup = Ember.Object.extend({
  content: [],
  date: null,

  todos: Ember.A([]),
  todoIds: function() {
    return this.get('todos').mapProperty('id').uniq();
  }.property('todos.@each.id').cacheable(),

  contacts: Ember.A([]),
  contactIds: function() {
    return this.get('contacts').mapProperty('id').uniq();
  }.property('contacts.@each.id').cacheable(),

  campaigns: Ember.A([]),
  campaignIds: function() {
    return this.get('campaigns').mapProperty('id').uniq();
  }.property('campaigns.@each.id').cacheable(),

  callLists: Ember.A([]),
  callListIds: function() {
    return this.get('callLists').mapProperty('id').uniq();
  }.property('callLists.@each.id').cacheable(),

  deals: Ember.A([]),
  dealIds: function() {
    return this.get('deals').mapProperty('id').uniq();
  }.property('deals.@each.id').cacheable(),

  meetings: Ember.A([]),
  meetingIds: function() {
    return this.get('meetings').mapProperty('id').uniq();
  }.property('meetings.@each.id').cacheable()
});