Radium.ActivitiesSystemController = Radium.ActivityBaseController.extend
  isLeadReceived: Ember.computed.equal 'event', 'lead_received'

  contact: Ember.computed.alias 'reference'
  source: Ember.computed.alias 'contact.source'

  eventName: Ember.computed.alias 'event'

  icon: Ember.computed 'event', ->
   switch @get('event')
     when 'lead_received' then 'user'
