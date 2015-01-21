Radium.ActivitiesExternalController = Radium.ActivityBaseController.extend
  unsubscribed: Ember.computed.equal 'event', 'unsubscribe'
