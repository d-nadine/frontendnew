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
  }
});