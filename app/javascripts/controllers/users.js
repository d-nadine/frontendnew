Radium.UsersController = Ember.ArrayProxy.extend({
  init: function(){
    this._super();
  },
  bootStrapLoaded: function(){
    var users = Radium.getPath('appController.users');
    
    Radium.store.loadMany(Radium.User, users);

    this.set('content', Radium.store.findMany(Radium.User, users.mapProperty('id').uniq()));
  }.observes('Radium.appController.users'),

  loggedInUser: function() {
    return Radium.store.find(Radium.User, Radium.getPath('appController.current_user.id'));
  }.property('Radium.appController.current_user').cacheable(),

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
  }.property('@each.emailAddresses').cacheable()
});
