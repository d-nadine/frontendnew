Radium.ClusterView = Radium.FeedView.extend({
  classNames: ['historical'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished',
    'isActionsVisible:expanded',
  ],
  isActionsVisible: false,
  layoutName: 'cluster_layout',
  defaultTemplate: 'default_activity',
  activityActionsView: Ember.ContainerView.extend({
    childViews: [],
    classNames: ['row'],
    contentBinding: 'parentView.content',
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    actionsVisibilityDidChange: function() {
      if (this.get('isActionsVisible')) {
        var activity = this.getPath('content.content');

        var activities = Radium.store.findMany(Radium.Activity, activity.get('activities').uniq());

        var containerView = Ember.ContainerView.create({});

        activities.forEach(function(activity){
          var view = Radium.HistoricalFeedView.create({
            content: activity,
            templateName: [activity.get('kind'), activity.get('tag')].join('_')
          });

          containerView.get('childViews').pushObject(view);
        });

        this.get('childViews').pushObject(containerView);
        // var clusterController = Radium.ClusterListController.create({});

        // clusterController.set('content', activities);

        // clusterController.batchloadViews(function(activity){
        //   if (activity) {
        //     return Ember.HistoricalFeedView.create({
        //       content: activity,
        //       templateName: [activity.get('kind'), activity.get('tag')].join('_')
        //     });
        //   }
        // });

        // this.get('childViews').pushObject(clusterController.get('view'));

        // this.$().addClass('loaded');
      }else{
        this.get('childViews').popObject();
        this.setPath('parentView.isEditMode', false);
      }
    }.observes('isActionsVisible')
  }),
});


