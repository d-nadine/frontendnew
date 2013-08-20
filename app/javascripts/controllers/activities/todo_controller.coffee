Radium.ActivitiesTodoController = Radium.ObjectController.extend
  isFinish: Ember.computed.is 'event', 'finish'
  isCreate: Ember.computed.is 'event', 'create'

  todo: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: (->
    switch @get('event')
      when 'finish' then 'todo'
      when 'create' then 'switch'
  ).property('event')

  eventName: (->
    "#{@get('event')}ed"
  ).property('event')
