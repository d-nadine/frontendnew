Radium.BillingInfo = Radium.Model.extend
  gatewayIdentifier: DS.attr('string')
  token: DS.attr('string')
  organisation: DS.attr('string')
  billingEmail: DS.attr('string')
  reference: DS.attr('string')
  phone: DS.attr('string')
  country: DS.attr('string')
  vat: DS.attr('string')
  subscription: DS.attr('string')
  trialStartDate: DS.attr('datetime')
  nextPaymentDue: DS.attr('datetime')
  subscriptionEnded: DS.attr('boolean')
  subscriptionEndDate: DS.attr('datetime')
  gatewaySet: DS.attr('boolean')
  hasSubscription: Ember.computed 'subscription', 'gatewaySet', ->
    return false if @get('subscriptionEnded')
    @get('gatewaySet') && @get('subscription') != 'basic'
