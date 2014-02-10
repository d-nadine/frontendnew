Radium.ActivitiesPhoneCallController = Radium.ActivityBaseController.extend
  isFinish: Ember.computed.is 'event', 'finish'
  isMissedCall: Ember.computed.is 'event', 'miss'

  call: Ember.computed.alias 'reference'
  to: Ember.computed.alias 'call.to'
  from: Ember.computed.alias 'call.from'
  length: Ember.computed.alias 'call.length'

  icon: (->
    switch @get('event')
      when 'finish' then 'phone'
      when 'miss' then 'phone-disabled'
  ).property('event')

  eventName: (->
    "#{@get('event')}ed"
  ).property('event')
