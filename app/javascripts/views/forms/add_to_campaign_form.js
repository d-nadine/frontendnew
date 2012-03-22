Radium.AddToCampaignForm = Radium.FormView.extend({
  templateName: 'add_to_campaign_form',
  selectedContactIdsBinding: 'Radium.contactsController.selectedContactsIds',
  submitForm: function() {
    var contacts = this.get('selectedContactIds'),
        campaignId = this.getPath('select.selection.id');
    debugger;
    $.ajax({
      url: '/api/campaigns/%@'.fmt(campaignId),
      type: 'PUT',
      data: {
        campaign: {
          contact_ids: contacts
        }
      }
    })
  }
});