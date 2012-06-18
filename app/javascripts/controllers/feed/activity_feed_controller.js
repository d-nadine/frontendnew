Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.BatchViewLoader, {
  content: Ember.A(),
  forwardContent: Radium.FutureFeed.create(),
  canScroll: true,
  init: function(){
    this._super();
    this.set('view', Ember.ContainerView.create());
    this.RequestDate = {};
    this.RequestDate[Radium.SCROLL_BACK] = 'previous_activity_date';
    this.RequestDate[Radium.SCROLL_FORWARD] = 'next_activity_date';

    this.RequestContent = {};
    this.RequestContent[Radium.SCROLL_BACK] = 'content';
    this.RequestContent[Radium.SCROLL_FORWARD] = 'forwardContent';
  },
  bootStraploaded: function(){
    this.set('previous_activity_date', Radium.getPath('appController.feed.previous_activity_date'));
    this.set('next_activity_date', Radium.getPath('appController.feed.next_activity_date'));
  }.observes('Radium.appController.feed'),

  shouldScroll: function(scrollData){
    return (this.get('canScroll') && (this.get(this.RequestDate[scrollData.direction])));
  },

  loadFeed: function(scrollData){
    if(!this.shouldScroll(scrollData)){
      return;
    }

    this.set('isLoading', true);
    
    var date = this.get(this.RequestDate[scrollData.direction]);

    var url = '/api/users/%@/feed?start_date=%@&end_date=%@'.fmt(Radium.getPath('appController.current_user.id'), date, date);
    
    var self = this;

    var contentKey = this.RequestContent[scrollData.direction];

    //TODO: Should we have a cluster ember-data model?
    $.when($.ajax({url: url})).then(function(data){
      if((data.feed.scheduled_activities.length > 0) || (data.feed.clusters.length > 0)){
        self.get(contentKey).pushObject(Ember.Object.create({dateHeader: self.get(self.RequestDate[scrollData.direction])}));
      }

      if(data.feed.scheduled_activities.length > 0){
        self.get(contentKey).pushObject(Radium.Utils.pluckReferences(data.feed.scheduled_activities));
      }

      if(data.feed.clusters.length > 0){
        self.get(contentKey).pushObjects(data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
      }

      if(data.feed.activities.length > 0){
        Radium.store.loadMany(Radium.Activity, data.feed.activities);
      }

      self.set(self.RequestDate[scrollData.direction], data.feed[self.RequestDate[scrollData.direction]]);

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
