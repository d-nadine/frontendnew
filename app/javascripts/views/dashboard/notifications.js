Radium.NotificationsView = Ember.View.extend({
  classNames: ['row'],
  templateName: 'notifications',
  didShowNotificationsChange: function() {
    if (this.getPath('controller.isVisible')) {
      this.$().slideDown('fast');
    } else {
      this.$().slideUp('fast');
    }
  }.observes('controller.isVisible'),
  isVisible: function() {
    return (this.getPath('content.length')) ? true : false;
  }.property('content.length'),
  notificationsListView: Ember.CollectionView.extend({
    contentBinding: 'parentView.content',
    itemViewClass: Radium.NotificationItemView
  })
});
