Radium.ClusterListController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
  },
  contentDidChange: function(){
    debugger;
    this.batchloadViews(function(activity){
      if (activity) {
        return Radium.ClusterView.create({
          content: activity,
          templateName: [activity.get('kind'), activity.get('tag')].join('_')
        });
      }
    });
  }
});
