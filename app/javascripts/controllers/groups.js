Radium.groupsController = Ember.ArrayProxy.create({
  content: [],
  names: function() {
    return this.getEach('name');
  }.property('@each.name').cacheable(),

  namesWithObject: function() {
    return this.map(function(item) {
      return {label: item.get('name'), group: item};
    });
  }.property('@each.name').cacheable()
});