Radium.accountController = Ember.Object.create({
  content: null,
  accountCreatedAt: function() {
    var date = this.getPath('content.createdAt').getTime();
    return Ember.DateTime.create(date).toFormattedString('%Y-%m-%d');
  }.property('content.createdAt').cacheable()
})