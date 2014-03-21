Radium.AccountController = Radium.ObjectController.extend
  hasGatewayAccount: Ember.computed 'billingInfo.gatewayIdentifier', ->
    return @get('billingInfo.gatewayIdentifier')
