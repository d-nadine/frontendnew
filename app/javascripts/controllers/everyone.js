Radium.EveryoneController = Ember.ArrayProxy.extend({
  userEmailsBinding: 'users.emails',
  contactEmailsBinding: 'contacts.emails',
  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  emails: function() {
    if (this.get('users')) {
      return this.get('users').toArray().concat(this.get('contacts').toArray());
    } else {
      return [];
    }
  }.property('userEmails.@each', 'contactEmails.@each'),

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