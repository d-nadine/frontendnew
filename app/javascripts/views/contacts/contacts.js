Radium.ContactsPageView = Ember.View.extend({
  templateName: 'contacts',

  selectedCampaignBinding: 'Radium.selectedContactsController.selectedCampaign',
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',

  noSelectedCampaigns: function() {
    return (this.get('selectedCampaign')) ? false : true;
  }.property('selectedCampaign').cacheable(),

  noSelectedFilter: function() {
    return (this.get('selectedFilter')) ? false : true;
  }.property('selectedFilter').cacheable(),

  campaignsFilterView: Ember.View.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked',

    allCampaigns: function(event) {
      Radium.App.send('allCampaigns');
      return false;
    }
  })
});

Radium.CampaignListView = Ember.View.extend({
  tagName: 'li',
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    var campaign = this.get('item'),
        selectedCampaign = this.getPath('parentView.parentView.selectedCampaign');
    if (campaign === selectedCampaign) { return true; }
  }.property('parentView.parentView.selectedCampaign').cacheable(),
  filterCampaigns: function(event) {
    var campaign = this.get('item');
    Radium.App.send('selectCampaign', campaign);
    return false;
  }
});