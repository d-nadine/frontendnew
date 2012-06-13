Radium.OverdueActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    this.set('content',Radium.Utils.transformActivities(Radium.getPath('appController.overdue_feed')));
  }.observes('Radium.appController.overdue_feed')
});
