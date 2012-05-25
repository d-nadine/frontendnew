/**
  A base button for the action buttons on a Campaign page. Since they are all
  bound to the page's form state, we want to disable them as a visual cue when
  another form is open.
*/
Radium.CampaignActionButton = Ember.View.extend({
  tagName: 'button',
  attributeBindings: ['disabled'],
  disabled: function() {
    var selectedForm = Radium.appController.get('selectedForm');
    return (selectedForm) ? true : false;
  }.property('Radium.appController.selectedForm').cacheable(),
});

Radium.CampaignPage = Ember.View.extend({
  templateName: 'campaign',
  // Chart
  campaignChart: Radium.PieChart.extend({
    chartTitleBinding: 'Radium.selectedCampaignController.content.name',
    title: function() {
      return this.get('chartTitle') + " Statistics";
    }.property('chartTitle'),
    seriesBinding: 'Radium.selectedCampaignController.campaignStats.chartData'
  }),

  // Campaign page action buttons
  emailButton: Radium.CampaignActionButton.extend({
    click: function() {
      Radium.App.send('addResource', 'Message');
    }
  }),
  smsButton: Radium.CampaignActionButton.extend({
    click: function() {
      // Radium.App.send('addResource', 'SMS');
    }
  }),
  todoButton: Radium.CampaignActionButton.extend({
    click: function() {
      Radium.App.send('addResource', 'Todo');
    }
  }),
  addTeamMemberButton: Radium.CampaignActionButton.extend({
    click: function() {
      // Radium.App.send('addResource', 'Messages');
    }
  }),
  addToCampaignButton: Radium.CampaignActionButton.extend({
    click: function() {
      // Radium.App.send('addResource', 'Messages');
    }
  }),
});