Radium.AccountController = Radium.ObjectController.extend
  hasGatewayAccount: Ember.computed 'billing.gatewayIdentifier', ->
    return @get('billing.gatewayIdentifier')
