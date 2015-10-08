Radium.Billing = Radium.Model.extend
  gatewayIdentifier: DS.attr('string')
  token: DS.attr('string')
  organisation: DS.attr('string')
  billingEmail: DS.attr('string')
  reference: DS.attr('string')
  phone: DS.attr('string')
  country: DS.attr('string')
  vat: DS.attr('string')
  subscriptionPlan: DS.belongsTo('Radium.SubscriptionPlan')
  trialStartDate: DS.attr('datetime')
  nextPaymentDue: DS.attr('datetime')
  subscriptionEnded: DS.attr('boolean')
  subscriptionEndDate: DS.attr('datetime')
  gatewaySet: DS.attr('boolean')
  isTrial: DS.attr('boolean')
  subscriptionInvalid: DS.attr('boolean')

  isBasic: Ember.computed 'subscriptionPlan.planId', ->
    @get('subscriptionPlan.planId') == 'basic'

  hasSubscription: Ember.computed 'subscriptionPlan', 'gatewaySet', ->
    return false if @get('subscriptionEnded')
    @get('gatewaySet') && !@get('isBasic')
