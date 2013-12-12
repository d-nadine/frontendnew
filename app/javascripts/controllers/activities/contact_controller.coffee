Radium.ActivitiesContactController = Radium.ObjectController.extend Radium.ActivityAssignMixin,
  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'
  isAssign: Ember.computed.is 'event', 'assign'
  isDelete: Ember.computed.is 'event', 'delete'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPrimaryContact: Ember.computed.is 'event', 'primary_contact'
  isNewEmail: Ember.computed.is 'event', 'new_email'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
  status: Ember.computed.alias 'meta.status'
  assignedTo: Ember.computed.alias 'meta.user'
  email: Ember.computed.alias 'meta.email'

  icon: (->
    switch @get('event')
      when 'create' then 'star'
      when 'update' then 'write'
      when 'assign' then 'transfer'
      when 'delete' then 'delete'
      when 'status_change' then 'chart'
      when 'primary_contact' then 'buildings'
      when 'new_email' then 'mail'
  ).property('event')
