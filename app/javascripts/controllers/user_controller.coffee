Radium.UserController = Radium.ObjectController.extend
  needs: ['accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.workflowStates')
  # FIXME: only allow current user to update their own details
  isEditable: true

  closedDealsTotal: ( ->
    @get('deals').filter (deal) ->
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
