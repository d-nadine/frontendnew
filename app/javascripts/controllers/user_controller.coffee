Radium.UserController = Radium.ObjectController.extend
  needs: ['teams']
  # FIXME: only allow current user to update their own details
  isEditable: true

  negotiatingDealsTotal: Radium.computed.total 'negotiatingDeals'

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
