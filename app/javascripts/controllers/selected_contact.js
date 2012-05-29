Radium.selectedContactController = Ember.Object.create({
  content: null,
  view: null,

  contentHasLoaded: function(){
    if(!this.getPath('content.isLoaded'))
      return;

    var contact = this.get('content'),
        contactId = contact.get('id')

    var contactFeed = Radium.feedController.create({
          init: function() {
              var pastDates = this.createDateRange({limit: 100}),
                  futureDates = this.createDateRange({limit: 60, direction: 1});

              this.set('futureDates', futureDates);
              this.set('pastDates', pastDates);
            },
            content: [],
            _pastDateHash: {},
            oldestDateLoaded: null,
            newestDateLoaded: null,
            oldestHistoricalDate: contact.get('createdAt'),
            lastDateLoaded: contact.get('updatedAt'),
            feedUrl: 'contacts/%@/feed/'.fmt(contactId)
        });
    
    this.get('view').set('controller', contactFeed);
    this.removeObserver('isLoaded', this, 'contentHasLoaded');
  }.observes('content.isLoaded')
});

