Radium.GroupFeedController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  forwardContent: Radium.FutureFeed.create(),
  content: Ember.A(),

  groupLoaded: function(){
    if(!this.getPath('group.isLoaded')){
      return;
    }

    var url =  Radium.get('appController').getFeedUrl('groups', this.getPath('group.id'));

    var options = this.getFeedOptions.call(this, url);

    this.loadFeed({direction: Radium.SCROLL_BACK}, options);
    
  }.observes('Radium.groupFeedController.group.isLoaded')
});
