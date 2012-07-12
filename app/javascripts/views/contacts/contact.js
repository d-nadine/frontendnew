Radium.ContactPageView = Ember.View.extend({
  templateName: 'contact',
  contactBinding: 'Radium.selectedContactController.contact',

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
