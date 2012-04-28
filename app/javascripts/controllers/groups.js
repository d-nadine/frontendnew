Radium.groupsController = Ember.ArrayProxy.create({
  content: [],
  names: function() {
    return this.getEach('name');
  }.property('@each.name').cacheable()
});