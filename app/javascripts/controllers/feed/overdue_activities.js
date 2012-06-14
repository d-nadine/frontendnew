Radium.OverdueActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    var activities = Radium.getPath('appController.overdue_feed'),
        references = Radium.Utils.pluckReferences(activities);
    
    this.set('content', references);
  }.observes('Radium.appController.overdue_feed')
});
