Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  notSelectable: ( ->
    return true if @get('isCurrent')
    !@get('hasGatewayAccount')
  ).property('hasGatewayAccount', 'isCurrent')

  isCurrent: ( ->
    @get('parentController.currentPlan') == @get('model')
  ).property('parentController.currentPlan', 'model')

  totalUsers: ( ->
    @get('model.totalUsers') - 1
  ).property('model.totalUsers')
