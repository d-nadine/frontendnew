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

    var self = this;

    var options = {
                    url: url,
                    requestDate: currentDate,
                    newFeedCallBack: function(feed){
                      self.set('previous_activity_date', feed.previous_activity_date);
                      self.set('next_activity_date', feed.next_activity_date);
                    }
                  }

    this.loadFeed({direction: Radium.SCROLL_BACK}, options);
    
  }.observes('Radium.groupFeedController.group.isLoaded')
});
