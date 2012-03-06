Radium.selectedUserFeedController = Radium.feedController.create({
  content: [],
  userSelected: function() {
    var selectedUserId = this.getPath('selectedUser.id');
    console.log('user selected', selectedUserId);
    var userFeed = Radium.Activity.filter(function(activity) {
      return activity.get('owner').user.id === selectedUserId;
    });
    this.set('content', userFeed);
  }.observes('selectedUser')
});