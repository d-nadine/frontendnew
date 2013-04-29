Radium.ContactController = Radium.ObjectController.extend
  needs: ['users', 'leadStatuses', 'groups', 'companies']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'
  companies: Ember.computed.alias 'controllers.companies'

  companyNames: ( ->
    return unless @get('companies.length')

    @get('companies').mapProperty('name')
  ).property('companies.[]')

  companyName: ( (key, value) ->
    if arguments.length == 1
      if @get('isNew')
        @get('model.companyName')
      else
        @get('company.name')
    else
      @set('model.companyName', value)
      value
  ).property('companyName', 'isNew', 'model')

  # FIXME: How do we determine this?
  isEditable: true

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  discussionForm: Radium.computed.newForm('discussion')

  discussionFormDefaults: (->
    reference: @get('model')
    user: @get('currentUser')
  ).property('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    location: ""
    isNew: true
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    user: @get('currentUser')
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
  ).property('model', 'now')

