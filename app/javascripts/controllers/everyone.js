Radium.everyoneController = Ember.ArrayProxy.extend({
  usersBinding: 'Radium.usersController.emails',
  contactsBinding: 'Radium.contactsController.emails',
  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  emails: function() {
    return this.get('users').concat(this.get('contacts'));
  }.property('users.@each', 'contacts.@each').cacheable(),

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
