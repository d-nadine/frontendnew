Radium.ContactPageView = Ember.View.extend({
  templateName: 'contact',
  contactBinding: 'Radium.selectedContactController.contact',
  addContactTodo: function() {
    Radium.get('formManager').send('showForm', {
      form: 'Todo',
      type: 'contacts',
      target: this.get('contact')
    });
    return false;
  },

  emailContact: function() {
    Radium.get('formManager').send('showForm', {
      form: 'Message',
      type: 'contacts',
      target: this.get('contact')
    });
    return false;
  },

  addContactToGroup: function() {
    Radium.get('formManager').send('showForm', {
      form: 'AddToGroup',
      target: this.get('contact')
    });
    return false;
  },

  addContactToCompany: function() {
    Radium.get('formManager').send('showForm', {
      form: 'AddToCompany',
      target: this.get('contact')
    });
    return false;
  }
});
