Radium.ContactsPageView = Ember.View.extend({
  templateName: 'contacts',

  campaignsFilterView: Ember.View.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked',
    selectedCampaignBinding: 'Radium.selectedContactsController.selectedCampaign',
    noSelectedCampaigns: function() {
      return (this.get('selectedCampaign')) ? false : true;
    }.property('selectedCampaign').cacheable(),

    allCampaigns: function(event) {
      Radium.selectedContactsController.setProperties({
        content: [],
        selectedCampaign: null
      });
      return false;
    }
  })
});

Radium.CampaignListView = Ember.View.extend({
  tagName: 'li',
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    var campaign = this.get('item'),
        selectedCampaign = Radium.selectedContactsController.get('selectedCampaign');
    if (campaign === selectedCampaign) { return true; }
  }.property('Radium.selectedContactsController.selectedCampaign').cacheable(),
  filterCampaigns: function(event) {
    var campaign = this.get('item');
    console.log(event, event.context);
    Radium.selectedContactsController.setProperties({
      content: campaign.get('contacts'),
      selectedCampaign: campaign
    });
    return false;
  }
});