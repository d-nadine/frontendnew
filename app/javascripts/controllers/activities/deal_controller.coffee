Radium.ActivitiesDealController = Radium.ObjectController.extend
  isDelete: Ember.computed.is 'event', 'delete'
  isAssign: Ember.computed.is 'event', 'assign'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPublish: Ember.computed.is 'event', 'publish'
  isClose: Ember.computed.is 'event', 'close'
  isLose: Ember.computed.is 'event', 'lose'

  deal: Ember.computed.alias 'reference'
  value: Ember.computed.alias 'deal.value'

  contact: Ember.computed.alias 'reference.contact'
  reassignedTo: Ember.computed.alias 'meta.user'
  status: Ember.computed.alias 'meta.status'
  isNegotiating: Ember.computed.alias 'meta.negotiating'

  icon: (->
    switch @get('event')
      when 'delete' then 'delete'
      when 'assign' then 'switch'
      when 'status_change' then 'chart'
      when 'close' then 'money'
      when 'lose' then 'i-dont-know'
      when 'publish' then 'quill'
  ).property('event')

  eventName: (->
    switch @get('event')
      when 'close' then 'closed'
      when 'lose' then 'lost'
      else @get('event')
  ).property('event')


