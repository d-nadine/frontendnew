Radium.StatCalculator = Ember.Object.extend({
  pendingDeals: function() {
    var deals = this.get('pending_deals'),
        currency = Ember.keys(deals);
    return deals[currency[0]];
  }.property('pending_deals'),
  
  closedDeals: function() {
    var deals = this.get('closed_deals'),
        currency = Ember.keys(deals);
    return deals[currency[0]];
  }.property('closed_deals'),
  
  paidDeals: function() {
    var deals = this.get('paid_deals'),
        currency = Ember.keys(deals);
    return deals[currency[0]];
  }.property('paid_deals'),

  rejectedDeals: function() {
    var deals = this.get('rejected_deals'),
        currency = Ember.keys(deals);
    return deals[currency[0]];
  }.property('rejected_deals'),
  chartData: function() {
    var pending = this.get('pendingDeals') || 0,
        closed =this.get('closedDeals') || 0,
        paid = this.get('paidDeals') || 0,
        rejected = this.get('rejectedDeals') || 0;
    return [
      ['Pending Deals', pending],
      ['Closed Deals', closed],
      ['Paid Deals', paid],
      ['Rejected Deals', rejected]
    ];
  }.property('pendingDeals', 'closedDeals', 'paidDeals', 'rejectedDeals'),
});

Radium.selectedCampaignController = Ember.Object.create({
  content: null,
  filterTypes: [
   {
      title: 'Everything', 
      shortname: 'everything', 
      hasForm: false
    },
    {
      title: 'Todos', 
      shortname: 'todo', 
      formViewClass: 'Todo',
      hasForm: true
    },
    {
      title: 'Meetings', 
      shortname: 'meeting', 
      formViewClass: 'Meeting',
      hasForm: true
    }, 
    {
      title: 'Phone Calls', 
      shortname: 'phonecall', 
      formViewClass: 'CallList',
      hasForm: true
    },
    {
      title: 'Deals', 
      shortname: 'deal', 
      formViewClass: 'Deal',
      hasForm: true
    },
    {
      title: 'Messages', 
      shortname: 'message',
      formViewClass: 'Message', 
      hasForm: true
    },
    {
      title: 'Discussions', 
      shortname: 'discussion', 
      formViewClass: 'Discussion',
      hasForm: true
    },
    {
      title: 'Pipeline', 
      shortname: 'pipeline', 
      hasForm: false
    }
  ],

  /**
    
  */
  campaignStats: null,

  addStatsData: function(data) {
    var stats = Radium.StatCalculator.create(data);
    this.set('campaignStats', stats);
  }
});