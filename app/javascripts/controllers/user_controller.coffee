Radium.UserController = Radium.ObjectController.extend
  # FIXME: only allow current user to update their own details
  isEditable: true

  workflowDealsTotal: Radium.computed.total 'workflowDeals'

  closedDealsTotal: Radium.computed.total 'closedDeals'

  currentMonth: ( ->
    Ember.DateTime.create().toFormattedString('%B')
  ).property()

  salesGoalPercentage: ( ->
    salesGoal = @get('salesGoal')
    closedDealsTotal = @get('closedDealsTotal')

    return 0 if !salesGoal || !closedDealsTotal

    Math.floor(closedDealsTotal / salesGoal)
  ).property('salesGoal', 'closedDealsTotal')
