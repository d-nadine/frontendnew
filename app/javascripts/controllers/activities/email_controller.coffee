Radium.ActivitiesEmailController = Radium.ObjectController.extend
  email: Ember.computed.alias 'reference'
  sender: Ember.computed.alias 'email.sender'
  recipients: Ember.computed.alias 'email.recipients'
