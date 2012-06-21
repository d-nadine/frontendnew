// TODO: Implement an `add` method for push notifications
// TODO: Add ability to accept/decline invitations versus just dismisal.
Radium.NotificationsController = Ember.ArrayController.extend({
  dismiss: function(event) {
    var notification = event.view.content;
    this.get('content').removeObject(notification);
    this.destroyNotification(notification);
    return false;
  },
  destroyNotification: function(notification) {
    notification.destroy();
    Radium.store.commit();
  },
  confirm: function(event) {
    var invitation = event.view.content,
        id = invitation.get('id'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/confirm'.fmt(id),
      type: 'PUT',
      context: this
    }).success(function() {
      content.removeObject(invitation);
      this.destroyNotification(invitation);
    });
    return false;
  },
  decline: function(event) {
    var invitation = event.view.content,
        id = invitation.get('id'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/reject'.fmt(id),
      type: 'PUT',
      context: this
    }).success(function() {
      content.removeObject(invitation);
      this.destroyNotification(invitation);
    });

    return false;
  },
  bootstrapLoaded: function(){
    this.set('content',  Radium.getPath('appController.notifications'));
  }.observes('Radium.appController.notifications')
});
