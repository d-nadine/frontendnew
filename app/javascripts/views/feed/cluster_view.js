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
        debugger;
        //TODO: use for real
        // var activities = Radium.store.findMany(Radium.Activity, this.content.itemIds.uniq()));
        var activities = Ember.A();

        for(var i = 0; i < 20; i++){
          activities.pushObject(this.content);
        }

        var clusterController = Radium.ClusterListController.create({});

        clusterController.set('content', activities);

        this.get('childViews').pushObject(clusterController.get('view'));
        this.$().addClass('loaded');
      }else{
        this.get('childViews').popObject();
        this.setPath('parentView.isEditMode', false);
      }
    }.observes('isActionsVisible')
  }),
});


