Radium.usersController = Ember.ArrayProxy.create({
  content: [],
  usersContactInfo: function() {
    return this.map(function(item) {
      return {
        label: item.get('name'), 
        value: item.get('id'),
        email: item.get('email'),
        phone: item.get('phone')
      };
    });
  }.property('@each.name').cacheable(),
  fetchUsers: function() {
    Radium.store.loadMany(Radium.User, Radium.User.FIXTURES);
    var self = this,
        content = Radium.store.findAll(Radium.User);
    this.set('content', content);
  },
  findUser: function(id) {
    return this.get('content').find(function(item) {
      return item.get('id') === id;
    });
  }
});