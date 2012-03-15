Radium.CampaignsPageView = Ember.View.extend({
  templateName: 'campaigns'
});

Radium.CampaignTableRow = Ember.View.extend({
  show: function(event) {
    var campaign = this.getPath('content');
    Radium.selectedCampaignController.set('content', campaign);
  }
});