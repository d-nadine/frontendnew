//TODO rename to ClusterFeedController
Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
  },
  bootStraploaded: function(){
    this.set('previous_activity_date', Radium.getPath('appController.feed.previous_activity_date'));
    this.set('next_activity_date', Radium.getPath('appController.feed.next_activity_date'));
  }.observes('Radium.appController.feed'),
  shouldScroll: function(){
    return this.get('previous_activity_date');
  },

  loadFeed: function(){
    this.set('isLoading', true);
    
    var date = this.get('previous_activity_date');

    var url = '/api/users/%@/feed?start_date=%@&end_date=%@'.fmt(Radium.getPath('appController.current_user.id'), date, date);
    
    var self = this;

    //TODO: Should we have a cluster ember-data model?
    $.when($.ajax({url: url})).then(function(data){
      if((data.feed.scheduled_activities.length > 0) || (data.feed.clusters.length > 0)){
        self.get('content').pushObject(Ember.Object.create({dateHeader: self.get('previous_activity_date')}));
      }

      if(data.feed.scheduled_activities.length > 0){
        var feed = Radium.getPath('appController.overdue_feed'),
          ids = feed.getEach('id');

        feed.forEach(function(item){
          var activity = item,
          kind = activity.kind,
          model = Radium[Radium.Utils.stringToModel(kind)],
          reference = activity.reference[kind];

          activity[kind] = reference;
        });

        if(!feed.length || feed.length === 0){
          self.get('content').pushObject(Ember.A());
        }else{
          Radium.store.loadMany(Radium.Activity, feed);
          self.get('content').pushObject(Radium.store.findMany(Radium.Activity, ids));
        } 
      }

      if(data.feed.clusters.length > 0){
        self.get('content').pushObjects(data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
      }

      if(data.feed.activities.length > 0){
        Radium.store.loadMany(Radium.Activity, data.feed.activities);
      }

      self.set('previous_activity_date', data.feed.previous_activity_date);

      self.set('foundData', data.feed.clusters.length > 0);
      self.set('isLoading', false);
      }).fail(function(){
        self.set('isLoading', false);
    });
  },

  bootstrapLoaded: function(){
    var clusters = Radium.getPath('appController.clusters');

    if (clusters) {
      this.set('content', clusters);
    }
  }.observes('Radium.appController.clusters')
});
