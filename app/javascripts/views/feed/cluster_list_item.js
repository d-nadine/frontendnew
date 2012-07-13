Radium.ClusterListItemView = Ember.ContainerView.extend({
  childViews: [],
  classNames: ['feed-cluster'],
  classNameBindings: ['content.kind'],
  init: function() {
    this._super();
    var self = this;

    //TODO: Can we use currentViewBinding for this
    //Computed property would be too expensive
    if(this.getPath('content.activities')){
      this.set('currentView', Radium.ClusterHeaderView.create());
    }else if(this.getPath('content.dateHeader')){
      this.set('currentView', Radium.DateHeaderView.create());
      this.classNames = [];
    }else if(this.getPath('content.message')){
      var self = this;
      this.classNames = [];
      this.set('currentView', Ember.View.create({
        content: self.get('content'),
        template: Ember.Handlebars.compile('<h4>{{content.message}}</h4>')
      }));
    }else{
      this.set('currentView', Radium.ScheduledActivityView.create());
    }
  },

  removeActivities: function() {
    var childViews = this.get('childViews');
    if (childViews.get('length') === 2) {
      // NOTE: There doesn't seem to be a way to run an animation
      // when an Ember View is about to be destroyed, using jQuery.Deferred
      // as a work around until a better solution is found.
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
