Radium.usersController = Ember.ArrayProxy.create({
  content: [],
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