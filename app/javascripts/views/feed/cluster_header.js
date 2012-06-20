Radium.ClusterHeaderView = Ember.View.extend({
  contentBinding: 'parentView.content',
  templateName: 'cluster_item',
  classNames: 'alert'.w(),
  classNameBindings: [
    'isActionsVisible:expanded'
  ],
  isActivitiesVisible: false,
  click: function() {
    var parentView = this.get('parentView');

    if (this.get('isActivitiesVisible')) {
      parentView.removeActivities();
    } else {
      var activityIds = this.getPath('content.activities');
      parentView.loadActivities(activityIds);
    }

    this.toggleProperty('isActivitiesVisible');
  },

  plurals: {
    "sms": "SMS's"
  },

  formats: {
    "sms": "SMS"
  },

  parseKindStrings: function(kindStr, count) {
    var formatted = kindStr.replace('_', ' ');

    if (count > 1) {
      return this.plurals[kindStr] || formatted + "s";
    } else {
      return this.formats[kindStr] || formatted;
    }
    
  },

  actions: {
    "scheduled_for": "scheduled",
    "became_prospect": "became a prospect",
    "became_dead_end": "became a dead end",
    "became_lead": "became a lead",
    "became_opportunity": "became an opportunity",
    "became_customer": "became a customer"
  },

  contextString: function(source) {
    var count = this.getPath('content.count'),
        kind = this.getPath('content.kind'),
        kindString = this.parseKindStrings(kind, count),
        tag = this.getPath('content.tag'),
        actionString = this.actions[tag] || tag;

    return "%@ %@".fmt(kindString, actionString);
  }.property('content.count')
});
