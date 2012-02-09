define('controllers/everyone', function(require) {
  
  var Radium = require('radium');

  Radium.everyoneController = Ember.ArrayProxy.create({
    usersBinding: 'Radium.usersController.usersContactInfo',
    contactsBinding: 'Radium.contactsController.contactsContactInfo',
    all: function() {
      var all = Ember.A([]);
      this.get('users').map(function(item) {
        all.pushObject(item);
      });

      this.get('contacts').map(function(item) {
        all.pushObject(item);
      });
      return all;
    }.property('users', 'contacts').cacheable()
  });

  return Radium;
});