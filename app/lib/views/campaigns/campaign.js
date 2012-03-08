Radium.CampaignPage = Ember.View.extend({
  templateName: 'campaign',
  campaignChart: Radium.PieChart.extend({
    chartTitleBinding: 'Radium.selectedCampaignController.content.name',
    title: function() {
      return this.get('chartTitle') + " Statistics";
    }.property('chartTitle'),
    seriesBinding: 'Radium.selectedCampaignController.campaignStats.chartData'
  }),
  actions: Ember.View.extend({
    test: function() {
      console.log(arguments);
    }
  }),
  emailButton: Ember.Button.extend({
    click: function() {
      // Radium.App.send('addResource', 'Message');
    }
  }),
  smsButton: Ember.Button.extend({
    click: function() {
      // Radium.App.send('addResource', 'SMS');
    }
  }),
  todoButton: Ember.Button.extend({
    click: function() {
      Radium.App.send('addResource', 'Todo');
    }
  }),
  addTeamMemberButton: Ember.Button.extend({
    click: function() {
      // Radium.App.send('addResource', 'Messages');
    }
  }),
  addToCampaignButton: Ember.Button.extend({
    click: function() {
      // Radium.App.send('addResource', 'Messages');
    }
  }),
});