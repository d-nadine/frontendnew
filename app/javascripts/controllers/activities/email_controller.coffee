Radium.ActivitiesEmailController = Radium.ActivityBaseController.extend
  email: Ember.computed.alias 'reference'
  sender: Ember.computed.alias 'email.sender'
  recipients: Ember.computed.alias 'email.recipients'

  icon: 'mail'
