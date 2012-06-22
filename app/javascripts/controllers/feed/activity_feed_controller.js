Radium.ActivityFeedController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  content: Ember.A(),
  forwardContent: Radium.FutureFeed.create(),
  dateHash: {},
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

  loadFeed: function(scrollData, dateToScrollTo){
    var isScroll = (arguments.length === 1);

    if(isScroll && (!this.shouldScroll(scrollData))){
      return;
    }

    this.set('isLoading', true);
    
    var getDate = (isScroll) ? this.get(this.RequestDate[scrollData.direction]) : dateToScrollTo;

    var self = this;

    var contentKey = this.RequestContent[scrollData.direction];

    var url = this.get('feedUrl')(getDate);

    $.when($.ajax({url: url})).then(function(data){
      if((data.feed.scheduled_activities.length > 0) || (data.feed.clusters.length > 0)){
        var dateContent = Ember.Object.create({dateHeader: getDate});
        
        self.get('dateHash')[getDate] = dateContent;
        
        self.get(contentKey).pushObject(dateContent);
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

      if(isScroll){
        self.set(self.RequestDate[scrollData.direction], data.feed[self.RequestDate[scrollData.direction]]);
      }

      self.set('isLoading', false);

      //TODO: Tightly coupled.  Should be raising an event to subscribers
      Ember.run.next(function(){
        Radium.get('appController').toggleKind();
      });
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
