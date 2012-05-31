Radium.UsersController = Ember.ArrayProxy.extend({
  content: [],
  init: function(){
    this._super();
    this.set('content', Radium.store.find(Radium.User, {page: 'all'}));
  },
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
  }.property('@each.name').cacheable(),

  emails: function() {
    return this.map(function(item) {
      var name = item.get('name'),
          email = item.get('email');
      return {
        label: "%@ <%@>".fmt(name, email),
        value: email,
        target: item
      };
    });
  }.property('@each.emailAddresses').cacheable(),
});
