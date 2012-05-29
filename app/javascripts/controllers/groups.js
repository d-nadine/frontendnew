Radium.groupsController = Ember.ArrayProxy.create({
  content: Radium.store.find(Radium.Group, {page: 'all'}),
  names: function() {
    return this.getEach('name');
  }.property('@each.name').cacheable(),

  namesWithObject: function() {
    return this.filterProperty('primaryContact', null).map(function(item) {
      return {label: item.get('name'), group: item};
    });
  }.property('@each.name').cacheable(),

  companiesWithObject: function() {
    return this.filterProperty('primaryContact', true).map(function(item) {
      return {label: item.get('name'), group: item};
    });
  }.property('@each.primaryContact').cacheable()
});