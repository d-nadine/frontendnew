Radium.AddToCampaignForm = Radium.FormView.extend({
  templateName: 'add_to_campaign_form',
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  submitForm: function() {
    var contacts = this.get('selectedContacts'),
        campaign = this.getPath('select.selection');
    contacts.forEach(function(item) {
      var campaigns = item.get('campaigns');
      if (campaigns.indexOf(campaign) < 0) { 
        item.get('campaigns').pushObject(campaign);
        campaign.get('contacts').pushObject(item);
        Radium.store.commit();
      }
    });
    this._super();
  }
});