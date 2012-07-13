Radium.GroupFeedController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  forwardContent: Radium.FutureFeed.create(),
  content: Ember.A(),

  groupLoaded: function(){
    if(!this.getPath('group.isLoaded')){
      return;
    }

    var feed = this.getPath('group.meta.feed'),
        currentDate = feed.current_date;

    if(!currentDate){
      this.get('content').pushObject({message: "There is no activity for this group."})
      return;
    }
  
    var url =  Radium.get('appController').getFeedUrl('groups', this.getPath('group.id'), currentDate);

    var options = this.getFeedOptions.call(this, url, currentDate);

    this.loadFeed({direction: Radium.SCROLL_BACK}, options);
    
  }.observes('Radium.groupFeedController.group.isLoaded')
});
