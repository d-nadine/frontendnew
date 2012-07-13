Radium.FeedScroller = Ember.Mixin.create(Ember.Evented, {
  content: Ember.A(),
  dateHash: {},
  canScroll: true,
  handler: null,
  init: function(){
    this._super();
    this.set('content', Ember.A());
    this.set('view', Ember.ContainerView.create());
    this.RequestDate = {};
    this.RequestDate[Radium.SCROLL_BACK] = 'previous_activity_date';
    this.RequestDate[Radium.SCROLL_FORWARD] = 'next_activity_date';

    this.RequestContent = {};
    this.RequestContent[Radium.SCROLL_BACK] = 'content';
    this.RequestContent[Radium.SCROLL_FORWARD] = 'forwardContent';
  },
  shouldScroll: function(scrollData){
    return (this.get('canScroll') && (this.get(this.RequestDate[scrollData.direction])));
  },

  loadFeed: function(scrollData, options){
    var isScroll = (arguments.length === 1);

    if(isScroll && (!this.shouldScroll(scrollData))){
      return;
    }

    this.set('isLoading', true);
    
    var getDate = (isScroll) ? this.get(this.RequestDate[scrollData.direction]) : options.requestDate;

    var self = this;

    var contentKey = this.RequestContent[scrollData.direction];

    var url = (isScroll) ? this.get('feedUrl')(getDate) : options.url;

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
      }else if(options.newFeedCallBack){
        options.newFeedCallBack(data.feed);
      }

      self.set('isLoading', false);

      Ember.run.next(function(){
        //TODO: Change fire to trigger on the next ember upgrade
        self.fire('onNewData');
      });
    }).fail(function(){
        self.set('isLoading', false);
    });
  }
});
