Radium.usersController = Ember.ArrayProxy.create({
  content: [],
  loggedInUser: function() {
    return this.filterProperty('isLoggedIn', true).get('firstObject');
  }.property('@each.isLoggedIn').cacheable()
});