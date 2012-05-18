Radium.accountController = Ember.Object.create({
  content: null,
  accountCreatedAt: function() {
    return this.getPath('content.createdAt').toFormattedString('%Y-%m-%d');
  }.property('content.createdAt').cacheable()
})