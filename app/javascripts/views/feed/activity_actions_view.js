Radium.ActivityActionsView = Ember.ContainerView.extend({
  childViews: [],
  classNames: ['row'],
  contentBinding: 'parentView.content',
  isActionsVisibleBinding: 'parentView.isActionsVisible',
  actionsVisibilityDidChange: function() {
    if (this.get('isActionsVisible')) {
      // Comments are either available from an embedded activity or from the
      // the activity itself if the view is historical.
      var activity = this.getPath('content.activity') || this.get('content'),
          commentsView = Radium.InlineCommentsView.create({
            controller: Radium.inlineCommentsController.create({
              activity: activity,
              contentBinding: 'activity.comments'
            }),
            contentBinding: 'controller.content'
          });
      this.get('childViews').pushObject(commentsView);
    } else {
      this.get('childViews').popObject();
      this.setPath('parentView.isEditMode', false);
    }
  }.observes('isActionsVisible')
});
