// TODO: Add string parsing so the notification line item is more descriptive.
Radium.NotificationItemView = Ember.View.extend({
  tagName: 'li',
  layoutName: 'notification_item',
  init: function() {
    this._super();
    var tag = this.getPath('content.tag').split('.'),
        context = tag[0],
        referenceType = tag[1];
    this.setProperties({
      templateName: referenceType + '_notification',
      context: context,
      isMeeting: (referenceType === 'meeting') ? true : false
    });
  }
});