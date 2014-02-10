Radium.ActivitiesCompanyController = Radium.ActivityBaseController.extend
  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'
  isAssign: Ember.computed.is 'event', 'assign'

  company: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: (->
    switch @get('isAssign')
      when 'assign' then 'buildings'
      when 'update' then 'write'
      else 'notebook'
  ).property('event')
