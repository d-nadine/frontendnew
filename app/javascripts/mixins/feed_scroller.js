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
    this.RequestDate[Radium.SCROLL_BACK] = 'previous_entry';
    this.RequestDate[Radium.SCROLL_FORWARD] = 'next_entry';

    this.RequestContent = {};
    this.RequestContent[Radium.SCROLL_BACK] = 'content';
    this.RequestContent[Radium.SCROLL_FORWARD] = 'forwardContent';
  },

  getFeedOptions: function(url, currentDate){
    var self = this;

    return  {
              url: url,
              requestDate: currentDate,
              newFeedCallBack: function(feed){
                self.set('previous_entry', feed.previous_entry);
                self.set('next_entry', feed.next_entry);
              }
            };
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
      var dateBookSection =  Radium.Utils.loadDateBook(data.feed.datebook_section);

      if((dateBookSection.length > 0) || (data.feed.historical_section.clusters.length > 0)){
        var dateToDisplay = getDate || data.feed.start_date;
        var dateContent = Ember.Object.create({
          dateHeader: dateToDisplay,
          dateString: function() {
            var dateHeader = this.get('dateHeader'),
                dateTime = Ember.DateTime.parse(dateToDisplay, '%Y-%m-%D'),
                today = Radium.appController.get('today'),
                yesterday = today.advance({day: -1}),
                tomorrow = today.advance({day: +1});

            if (Ember.DateTime.compareDate(today, dateTime) === 0) {
              return "Today";
            }

            else if (Ember.DateTime.compareDate(yesterday, dateTime) === 0) {
              return "Yesterday";
            }

            else if (Ember.DateTime.compareDate(tomorrow, dateTime) === 0) {
              return "Tomorrow";
            }

            else {
              return dateTime.toFormattedString('%A, %B %D, %Y');
            }
          }.property('dateHeader')
        });

        self.get('dateHash')[dateToDisplay] = dateContent;

        self.get(contentKey).pushObject(dateContent);
      }

      if(dateBookSection.length > 0){
        self.get(contentKey).pushObject(dateBookSection);
      }

      if(data.feed.historical_section.clusters.length > 0){
        self.get(contentKey).pushObjects(data.feed.historical_section.clusters.map(function(data) { return Ember.Object.create(data); }));
      }

      // if(data.feed.activities.length > 0){
      //   Radium.store.loadMany(Radium.Activity, data.feed.activities);
      // }

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
