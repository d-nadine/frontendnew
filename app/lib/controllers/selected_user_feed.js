Radium.selectedUserFeedController = Radium.feedController.create({
  content: [],
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Todos', 
      shortname: 'todo', 
      formViewClass: 'Todo',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Meetings', 
      shortname: 'meeting', 
      formViewClass: 'Meeting',
      isMain: false
    }), 
    Ember.Object.create({
      title: 'Phone Calls', 
      shortname: 'phonecall', 
      formViewClass: 'CallList',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Deals', 
      shortname: 'deal', 
      formViewClass: 'Deal',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Messages', 
      shortname: 'message',
      formViewClass: 'Message', 
      isMain: false
    }),
    Ember.Object.create({
      title: 'Discussions', 
      shortname: 'discussion', 
      formViewClass: 'Discussion',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Pipeline', 
      shortname: 'pipeline', 
      isMain: true
    })
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