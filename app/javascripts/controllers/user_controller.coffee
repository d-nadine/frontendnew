Radium.UserController = Radium.ObjectController.extend
  needs: ['users', 'contacts','tags', 'companies', 'countries', 'accountSettings', 'contactStatuses']
  loadedPages: [1]

  statuses: Ember.computed.alias('controllers.accountSettings.dealStates')
  isEditable: true
  isEditing: false

  users: Ember.computed.oneWay 'controllers.users'

  userIsCurrentUser: Ember.computed 'model', 'currentUser', ->
    @get('model') == @get('currentUser')

  closedDealsTotal: Ember.computed 'deals.[]', ->
    deals = @get('deals')

    return unless deals

    deals.filter (deal) ->
      deal.get('status') == 'closed'

  currentMonth: Ember.computed ->
    Ember.DateTime.create().toFormattedString('%B')

  salesGoalPercentage: Ember.computed 'salesGoal', 'closedDealsTotal', ->
    salesGoal = @get('salesGoal')
    closedDealsTotal = @get('closedDealsTotal')

    return 0 if !salesGoal || !closedDealsTotal

    Math.floor(closedDealsTotal / salesGoal)

  canDelete: Ember.computed 'userIsCurrentUser', 'currentUser.isAdmin', ->
    !@get('userIsCurrentUser') && @get('currentUser.isAdmin')

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model') unless @get('model') == @get('currentUser')
    user: @get('currentUser')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Ember.A()
    contacts: Em.A()
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()
