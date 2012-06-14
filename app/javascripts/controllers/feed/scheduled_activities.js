Radium.ScheduledActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    var activities = Radium.getPath('appController.scheduled_feed'),
        references = Radium.Utils.pluckReferences(activities);
    
    this.set('content', references);
  }.observes('Radium.appController.scheduled_feed')
});
