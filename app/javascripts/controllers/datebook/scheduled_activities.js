Radium.ScheduledActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    var feed = Radium.getPath('appController.scheduled_feed'),
        ids = feed.getEach('id');

    feed.forEach(function(item){
      var activity = item,
          kind = activity.kind,
          model = Radium[Radium.Utils.stringToModel(kind)],
          reference = activity.reference[kind];

      activity[kind] = reference;
    });

    if(!feed.length || feed.length === 0){
      this.set('content', []);
      return;
    }

    Radium.store.loadMany(Radium.Activity, feed);
    this.set('content', Radium.store.findMany(Radium.Activity, ids));

  }.observes('Radium.appController.scheduled_feed')
});