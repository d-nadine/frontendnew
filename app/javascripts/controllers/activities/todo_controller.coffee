Radium.ActivitiesTodoController = Radium.ActivityBaseController.extend Radium.ActivityAssignMixin,
  isFinish: Ember.computed.is 'event', 'finish'
  isCreate: Ember.computed.is 'event', 'create'
  isAssign: Ember.computed.is 'event', 'assign'

  # todo: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: (->
    switch @get('event')
      when 'finish' then 'check'
      when 'create' then 'transfer'
      when 'assign' then 'transfer'
  ).property('event')

  eventName: (->
    "#{@get('event')}ed"
  ).property('event')
