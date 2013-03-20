Radium.FormsEmailController = Ember.ObjectController.extend Ember.Evented,
  needs: ['groups','contacts','users','clock']
  now: Ember.computed.alias('clock.now')

