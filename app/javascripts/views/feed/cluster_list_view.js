Radium.ClusterListView = Ember.ContainerView.extend({
  childViews: [],
  // currentView: Radium.ClusterHeaderView,
  init: function() {
    this._super();
    this.set('currentView', Radium.ClusterHeaderView.create());
  },

  removeActivities: function() {
    var childViews = this.get('childViews');
    if (childViews.get('length') === 2) {
      $.when(childViews.objectAt(1).slideUp()).then(function() {
        childViews.popObject();
      });      
    }
  },

  loadActivities: function(ids) {
    var activities = Radium.store.findMany(Radium.Activity, ids),
        activityListController = Ember.ArrayProxy.create({
            content: activities
          }),
      activitiesListView = Radium.ClusterActivityListView.create({
          controller: activityListController,
          contentBinding: 'controller.content'
        });
    this.get('childViews').pushObject(activitiesListView);
  }
});