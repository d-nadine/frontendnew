Radium.NotificationsController = Ember.ArrayController.extend({
  isVisible: true,
  toggleNotifications: function(event) {
    this.toggleProperty('isVisible');
    return false;
  },
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
    var notification = event.view.content,
        invitation = notification.get('invitation'),
        hashKey = invitation.get('hashKey'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/confirm'.fmt(hashKey),
      type: 'PUT',
      context: this
    }).success(function() {
      content.removeObject(notification);
      this.destroyNotification(notification);
    });
    return false;
  },
  decline: function(event) {
    var notification = event.view.content,
        invitation = notification.get('invitation'),
        hashKey = invitation.get('hashKey'),
        content = this.get('content');
    $.ajax({
      url: '/api/invitation/%@/reject'.fmt(hashKey),
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
