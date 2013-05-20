Radium.ActivitiesDealController = Radium.ObjectController.extend
  isDelete: Ember.computed.is 'event', 'delete'
  isAssign: Ember.computed.is 'event', 'assign'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPublish: Ember.computed.is 'event', 'publish'
  isClose: Ember.computed.is 'event', 'close'
  isLose: Ember.computed.is 'event', 'lose'
  isReopen: Ember.computed.is 'event', 'reopen'
  isPay: Ember.computed.is 'event', 'pay'

  deal: Ember.computed.alias 'reference'
  value: Ember.computed.alias 'deal.value'

  contact: Ember.computed.alias 'reference.contact'
  company: Ember.computed.alias 'reference.company'
  reassignedTo: Ember.computed.alias 'meta.user'
  status: Ember.computed.alias 'meta.status'
  isNegotiating: Ember.computed.alias 'meta.negotiating'

  icon: (->
    switch @get('event')
      when 'delete' then 'delete'
      when 'assign' then 'switch'
      when 'status_change' then 'chart'
      when 'close' then 'money'
      when 'lose' then 'money'
      when 'pay' then 'money'
      when 'publish' then 'quill'
      when 'reopen' then 'spinner'
  ).property('event')

  eventName: (->
    switch @get('event')
      when 'close' then 'closed'
      when 'lose' then 'lost'
      else @get('event')
  ).property('event')
