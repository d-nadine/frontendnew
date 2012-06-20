// TODO: Add string parsing so the notification line item is more descriptive.
Radium.NotificationItemView = Ember.View.extend({
  tagName: 'li',
  layoutName: 'notification_item',
  assignedTemplates: {
    contact: '<a href="/contacts/{{unbound contact.id}}">{{contact.displayName}}</a> has been assigned to you.',
    todo: 'Todo {{todo.description}} has been assigned to you.',
    campaign: '<a href="/campaigns/{{unbound campaign.id}}">{{campaign.name}}</a> has been assigned to you.',
    deal: '<a href="/deals/{{unbound deal.id}}">{{deal.name}}</a> has been assigned to you.'
  },
  init: function() {
    this._super();
    // Notification tags are technically 2 tags joined by a '.'
    // Convention is {action}.{reference}, e.g. `confirmed.meeting`
    var tag = this.getPath('content.tag'),
        tagStrings = tag.split('.'),
        action = tagStrings[0],
        referenceType = tagStrings[1];
    // Assigned notifications are a simple one liner
    if (action === 'assigned') {
      this.set('template', Ember.Handlebars.compile(this.assignedTemplates[referenceType]));
    } else {
      this.setProperties({
        templateName: tag + '_notification',
        isMeetingInvite: (tag === 'invited.meeting') ? true : false
      });
    }
  }
});