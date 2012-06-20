// TODO: Implement an `add` method for push notifications
// TODO: Add ability to accept/decline invitations versus just dismisal.
Radium.NotificationsController = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.set('content', Radium.store.findAll(Radium.Notification));
  },
  dismiss: function(event) {
    this.get('content').removeObject(event.view.content);
    return false;
  }
});