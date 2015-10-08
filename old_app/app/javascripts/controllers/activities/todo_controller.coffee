Radium.ActivitiesTodoController = Radium.ActivityBaseController.extend Radium.ActivityAssignMixin,
  isFinish: Ember.computed.is 'event', 'finish'
  isCreate: Ember.computed.is 'event', 'create'
  isAssign: Ember.computed.is 'event', 'assign'

  assignedTo: Ember.computed.alias 'meta.user'

  icon: Ember.computed 'event', ->
    switch @get('event')
      when 'finish' then 'check'
      when 'create' then 'transfer'
      when 'assign' then 'transfer'

  eventName: Ember.computed 'event', ->
    "#{@get('event')}ed"
