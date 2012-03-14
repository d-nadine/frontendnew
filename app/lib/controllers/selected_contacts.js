Radium.selectedContactsController = Ember.ArrayProxy.create({
  content: [],
  selectedCampaign: null,
  uncheckContacts: function() {
    Radium.contactsController.setEach('isSelected', false);
  }.observes('content.@each')
});