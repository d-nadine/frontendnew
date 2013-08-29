Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  notSelectable: ( ->
    !@get('hasGatewayAccount')
  ).property('hasGatewayAccount')
