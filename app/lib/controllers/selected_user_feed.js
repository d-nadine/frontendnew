Radium.selectedUserFeedController = Radium.feedController.create({
  content: [],
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
  userSelected: function() {
    var selectedUserId = this.getPath('selectedUser.id');
    console.log('user selected', selectedUserId);
    var userFeed = Radium.Activity.filter(function(activity) {
      return activity.get('owner').user.id === selectedUserId;
    });
    this.set('content', userFeed);
  }.observes('selectedUser')
});