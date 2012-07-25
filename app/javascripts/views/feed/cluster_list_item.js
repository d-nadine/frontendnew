Radium.ClusterListItemView = Ember.ContainerView.extend({
  childViews: [],
  classNames: ['feed-cluster'],
  classNameBindings: ['content.kind'],
  init: function() {
    this._super();
    var activityIds = this.getPath('content.activities');
    //TODO: Can we use currentViewBinding for this
    //Computed property would be too expensive
    if (activityIds) {
      this.set('currentView', Radium.ClusterHeaderView.create());
    } else if (this.getPath('content.dateHeader')) {
      this.set('currentView', Radium.DateHeaderView.create());
      this.classNames = [];
    } else if (this.getPath('content.message')) {
      this.classNames = [];
      this.set('currentView', Ember.View.create({
        content: this.get('content'),
        template: Ember.Handlebars.compile('<h4>{{content.message}}</h4>')
      }));
    } else {
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

  showActivities: function() {
    var self = this,
        activityIds = this.getPath('content.activities'),
        resources = Radium.store.find(Radium.Activity, {ids: activityIds});

    this.set('controller', Ember.ArrayProxy.create({
      content: resources
    }));

    resources.addObserver('isLoaded', function() {
      if (this.get('isLoaded')) {
        var activitiesListView = Radium.ClusterActivityListView.create({
              contentBinding: 'parentView.controller.content'
            });
        self.get('childViews').pushObject(activitiesListView);
      }
    });
  }
});
