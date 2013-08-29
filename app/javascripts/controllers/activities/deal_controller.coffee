Radium.ActivitiesDealController = Radium.ObjectController.extend Radium.ActivityAssignMixin,
  isCreate: Ember.computed.is 'event', 'create'
  isDelete: Ember.computed.is 'event', 'delete'
  isAssign: Ember.computed.is 'event', 'assign'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPublish: Ember.computed.is 'event', 'publish'
  isClose: Ember.computed.is 'event', 'close'
  isLose: Ember.computed.is 'event', 'lose'
  isReopen: Ember.computed.is 'event', 'reopen'
  isPay: Ember.computed.is 'event', 'value_change'

  deal: Ember.computed.alias 'reference'
  value: Ember.computed.alias 'deal.value'

  contact: Ember.computed.alias 'reference.contact'
  company: Ember.computed.alias 'reference.company'
  status: Ember.computed.alias 'meta.status'
  isNegotiating: Ember.computed.alias 'meta.negotiating'

  icon: (->
    switch @get('event')
      when 'create' then 'plus'
      when 'delete' then 'delete'
      when 'assign' then 'transfer'
      when 'status_change' then 'chart'
      when 'close' then 'dollarsign'
      when 'lose' then 'dollarsign'
      when 'pay' then 'dollarsign'
      when 'publish' then 'write'
      when 'reopen' then 'plus'
  ).property('event')

  eventName: (->
    switch @get('event')
      when 'close' then 'closed'
      when 'lose' then 'lost'
      else @get('event')
  ).property('event')
