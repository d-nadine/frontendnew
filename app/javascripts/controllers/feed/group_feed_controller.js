Radium.GroupFeedController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  forwardContent: Radium.FutureFeed.create(),
  content: Ember.A(),

  groupLoaded: function(){
    if(!this.getPath('group.meta.feed')){
      return;
    }

    var feed = this.getPath('group.meta.feed'),
        currentDate = feed.current_date;
  
    this.set('previous_activity_date', Radium.getPath('start_date'));
    this.set('next_activity_date', Radium.getPath('end_date'));

    var url =  Radium.get('appController').getFeedUrl('groups', this.getPath('group.id'), currentDate),
        content = this.get('content');

    var content = this.get('content');
    $.when($.ajax({url: url})).then(function(data){
      content.pushObject(Ember.Object.create({dateHeader: 'Today'}));

      if(data.feed.scheduled_activities.length > 0){
        content.pushObject(Radium.Utils.pluckReferences(data.feed.scheduled_activities));
      }else{
        content.pushObject(Ember.Object.create({message: "Nothing Scheduled."}));
      }
    });

  }.observes('Radium.groupFeedController.group.meta.feed')
});
