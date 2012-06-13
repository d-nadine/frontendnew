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

  finishByDate: function() {
    return this.getPath('content.endsAt');
  }.property('content').cacheable()
});