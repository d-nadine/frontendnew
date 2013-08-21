Radium.ActivitiesContactController = Radium.ObjectController.extend Radium.ActivityAssignMixin,
  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'
  isAssign: Ember.computed.is 'event', 'assign'
  isDelete: Ember.computed.is 'event', 'delete'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPrimaryContact: Ember.computed.is 'event', 'primary_contact'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
  status: Ember.computed.alias 'meta.status'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: (->
    switch @get('event')
      when 'create' then 'contact-plus'
      when 'update' then 'edit'
      when 'assign' then 'switch'
      when 'delete' then 'contact-cancel'
      when 'status_change' then 'chart'
      when 'primary_contact' then 'office'
  ).property('event')
