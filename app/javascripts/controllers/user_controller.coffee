Radium.UserController = Radium.ObjectController.extend
  needs: ['accountSettings']
  needs: ['users', 'contacts','tags', 'companies', 'countries', 'accountSettings', 'leadStatuses']
  compactFormButtons: true
  loadedPages: [1]

  statuses: Ember.computed.alias('controllers.accountSettings.dealStates')
  stats: ['stuff', 'crap']
  isEditable: true
  isEditing: false

  userIsCurrentUser: ( ->
    @get('model') == @get('currentUser')
  ).property('model', 'currentUser')

  closedDealsTotal: ( ->
    deals = @get('deals')

    return unless deals

    deals.filter (deal) ->
      deal.get('status') == 'closed'
  ).property('deals.[]')

  currentMonth: ( ->
    Ember.DateTime.create().toFormattedString('%B')
  ).property()

  salesGoalPercentage: ( ->
    salesGoal = @get('salesGoal')
    closedDealsTotal = @get('closedDealsTotal')

    return 0 if !salesGoal || !closedDealsTotal

    Math.floor(closedDealsTotal / salesGoal)
  ).property('salesGoal', 'closedDealsTotal')

  formBox: (->
    Radium.FormBox.create
      compactFormButtons: true
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model') unless @get('model') == @get('currentUser')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    contact: @get('model')
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
    reference: @get('model')
    users: Ember.A()
    contacts: Em.A()
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()
  ).property('model', 'now')
