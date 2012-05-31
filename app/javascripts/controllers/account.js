Radium.AccountController = Ember.Object.extend({
  content: null,
  accountCreatedAt: function() {
    return this.getPath('content.createdAt').toFormattedString('%Y-%m-%d');
  }.property('content.createdAt').cacheable()
});
