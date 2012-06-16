Radium.EveryoneController = Ember.ArrayProxy.extend({
  userEmailsBinding: 'usersController.emails',
  contactEmailsBinding: 'contactsController.emails',
  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  emails: function() {
    if (this.get('userEmails')) {
      return this.get('userEmails').toArray().concat(this.get('contactEmails').toArray());
    } else {
      return [];
    }
  }.property('userEmails.@each', 'contactEmails.@each'),

  all: function() {
    var all = Ember.A([]);
    this.get('contactEmails').map(function(item) {
      all.pushObject(item);
    });

    this.get('contactEmails').map(function(item) {
      all.pushObject(item);
    });
    return all;
  }.property('userEmails', 'contactEmails')
});