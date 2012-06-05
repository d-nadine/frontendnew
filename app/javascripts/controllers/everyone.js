Radium.everyoneController = Ember.ArrayProxy.create({
  usersBinding: 'Radium.usersController.content',
  contactsBinding: 'Radium.contactsController.content',
  userEmailsBinding: 'users.emails',
  contactEmailsBinding: 'contacts.emails',
  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  emails: function() {
    return this.get('users').concat(this.get('contacts'));
  }.property('userEmails.@each', 'contactEmails.@each'),

  flaggedTo: function() {
    var flaggedUsers = this.get('users'),
        flaggedContacts = this.get('contacts');
  }.property('users.@each.messageFlag', 'contacts.@each.messageFlag'),

  all: function() {
    var all = Ember.A([]);
    this.get('users').map(function(item) {
      all.pushObject(item);
    });

    this.get('contacts').map(function(item) {
      all.pushObject(item);
    });
    return all;
  }.property('userEmails', 'contactEmails')
});