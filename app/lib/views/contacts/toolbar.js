Radium.ContactsToolbarView = Ember.View.extend({
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  isContactsSelected: function() {
    return (this.getPath('selectedContacts.length') === 0) ? true : false;
  }.property('selectedContacts').cacheable(),
  emailButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'Message');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  smsButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'Message');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  todoButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'Todo');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  callListButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'CallList');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  addCampaignButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'AddToCampaign');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  removeCampaignButton: Ember.Button.extend({
    click: function() {
      var contacts = this.getPath('parentView.selectedContacts');
      contacts.forEach(function(item) {
        var campaigns = item.get('campaigns');
        item.get('campaigns').removeObjects(campaigns);
      }, this);

      Radium.store.commit();
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),
  statusButton: Ember.Button.extend({
    click: function() {
    },
    disabledBinding: 'parentView.isContactsSelected'
  })
});