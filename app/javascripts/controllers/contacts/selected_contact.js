Radium.SelectedContactController = Ember.ArrayProxy.extend(Radium.FeedScroller, { 
  contact: null,
  contactLoaded: function(){
    if(!this.getPath('contact.isLoaded')){
      return;
    }

    var feed = this.getPath('contact.meta.feed'),
        currentDate = feed.current_date;

    if(!currentDate){
      this.get('content').pushObject({message: "There is no activity for this contact."});
      return;
    }
  
    var url =  Radium.get('appController').getFeedUrl('contacts', this.getPath('contact.id'), currentDate);

    var self = this;

    var options = {
                    url: url,
                    requestDate: currentDate,
                    newFeedCallBack: function(feed){
                      self.set('previous_activity_date', feed.previous_activity_date);
                      self.set('next_activity_date', feed.next_activity_date);
                    }
                  };

    this.loadFeed({direction: Radium.SCROLL_BACK}, options);

  }.observes('Radium.selectedContactController.contact.isLoaded')
});

