Radium.FeedGroup = Ember.Object.extend({
  content: [],
  date: null,

  hasVisibleContent: function() {
    return this.getPath('historical.length');
  }.property('historical.length').cacheable()
});