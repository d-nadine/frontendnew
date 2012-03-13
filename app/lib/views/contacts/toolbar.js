Radium.ContactsToolbarView = Ember.View.extend({
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',

  // Bind all child buttons' `disabled` property here
  isContactsSelected: function() {
    return (this.getPath('selectedContacts.length') === 0) ? true : false;
  }.property('selectedContacts').cacheable(),

  /**
    Bulk assigns contacts status as Dead End, Opportunity, Prospect,
    Client or Lead. `Change Status` dropdown buttons call this.
  */
  assignStatus: function(event) {
    var contacts = this.get('selectedContacts'),
        newStatus = event.target.innerText;
    // Hide all open dropdown menus
    this.$('.btn-group').toggleClass('open');
    contacts.setEach('status', newStatus);

    event.preventDefault();
    return false;
  },

  /**
    Opens New Message form in the main page state
  */
  emailButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'ContactsMessage');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens New SMS form in the main page state
  */
  smsButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'ContactSMS');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add Todo form in the main page state
  */
  todoButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'Todo');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add to Call List form in the main page state
  */
  callListButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'CallList');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add Campaign form in the main page state
  */
  addCampaignButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'AddToCampaign');
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Removes a selected user from a campaign
  */
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

  /**
    Opens dropdown menu to batch assign contacts
    @extend Radium.DropdownButton
  */
  statusButton: Radium.DropdownButton.extend({
    disabledBinding: 'parentView.isContactsSelected'
  })
});