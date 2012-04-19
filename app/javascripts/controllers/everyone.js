Radium.everyoneController = Ember.ArrayProxy.create({
  usersBinding: 'Radium.usersController.usersContactInfo',
  contactsBinding: 'Radium.contactsController.contactsContactInfo',
  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  everyonesEmail: function() {
    var allEmails = Ember.A([]);
    this.get('users').forEach(function(item) {
      item.get('emailAddresses').forEach(function(email) {
        allEmails.pushObject(email.get('value'));
      });
    });

    this.get('contacts').forEach(function(item) {
      item.get('emailAddresses').forEach(function(email) {
        allEmails.pushObject(email.get('value'));
      });
      
    });
    return allEmails;
  }.property('@each.name').cacheable(),

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