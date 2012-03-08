Radium.usersController = Ember.ArrayProxy.create({
  content: [],
  loggedInUser: function() {
    return this.filterProperty('isLoggedIn', true).get('firstObject');
  }.property('@each.isLoggedIn').cacheable(),
  usersContactInfo: function() {
    return this.map(function(item) {
      return {
        label: item.get('name'), 
        value: item.get('id'),
        email: item.get('email'),
        phone: item.get('phone')
      };
    });
  }.property('@each.name').cacheable()
});