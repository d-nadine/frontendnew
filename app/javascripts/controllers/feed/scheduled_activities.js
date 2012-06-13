Radium.ScheduledActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    this.set('content',Radium.Utils.transformActivities(Radium.getPath('appController.scheduled_feed')));
  }.observes('Radium.appController.scheduled_feed')
});
