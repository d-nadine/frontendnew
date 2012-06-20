Radium.NotificationsView = Ember.View.extend({
  classNames: ['row'],
  templateName: 'notifications',
  hideNotifications: function(event) {
    var self = this;
    $.when(this.$().slideUp('fast'))
      .then(function() {
        self.set('content', []);
      });
    return false;
  },
  // contentArrayDidChange: function() {
  //   if (this.getPath('content.length')) {
  //     this.set('isVisible', true);
  //   } else {
  //     this.set('isVisible', false);
  //   }
  // }.observes('content.length'),
  isVisible: function() {
    return (this.getPath('content.length')) ? true : false;
  }.property('content.length'),
  notificationsListView: Ember.CollectionView.extend({
    contentBinding: 'parentView.content',
    itemViewClass: Radium.NotificationItemView
  })
});