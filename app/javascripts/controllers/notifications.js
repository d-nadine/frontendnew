// TODO: Implement an `add` method for push notifications
// TODO: Add ability to accept/decline invitations versus just dismisal.
Radium.NotificationsController = Ember.ArrayController.extend({
  dismiss: function(event) {
    this.get('content').removeObject(event.view.content);
    return false;
  },
  confirm: function(event) {
    var invitation = event.view.content,
        id = invitation.get('id'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/confirm'.fmt(id),
      type: 'PUT'
    }).success(function() {
      content.removeObject(invitation);
    });
    return false;
  },
  decline: function(event) {
    var invitation = event.view.content,
        id = invitation.get('id'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/reject'.fmt(id),
      type: 'PUT'
    }).success(function() {
      content.removeObject(invitation);
    });

    return false;
  },
  bootstrapLoaded: function(){
    this.set('content',  Radium.getPath('appController.notifications'));
  }.observes('Radium.appController.notifications')
});
