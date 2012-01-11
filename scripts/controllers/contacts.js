define('controllers/contacts', function(require) {
  
  require('ember');
  require('data')
  var Radium = require('radium');
  require('models/user');
  require('fixtures/contacts');
  
  Radium.contactsController = Ember.ArrayProxy.create({
    content: [],
    fetchContacts: function() {
      Radium.store.loadMany(Radium.Contact, Radium.Contact.FIXTURES);
      var self = this,
          content = Radium.store.findAll(Radium.Contact);
      this.set('content', content);
    },
    findContact: function(id) {
      return this.get('content').find(function(item) {
        return item.get('id') === id;
      });
    }
  });
  
  return Radium;
  
});