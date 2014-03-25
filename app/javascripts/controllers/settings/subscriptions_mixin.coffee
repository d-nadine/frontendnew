Radium.SubscriptionMixin = Ember.Mixin.create
  needs: ['subscriptionPlans']
  subscriptionPlans: Ember.computed.alias 'controllers.subscriptionPlans'
  currentPlan: ( ->
    subscription = @get('account.billingInfo.subscription')
    return unless subscription

    subscriptionPlans = @get('subscriptionPlans')
    return unless subscriptionPlans.get('length')

    @get('subscriptionPlans').find (plan) => plan.get('name') == subscription
  ).property('subscriptionPlans.[]', 'account.billingInfo.subscription')

  totalUsers: ( ->
    if @get('currentPlan.name') == 'basic'
      1
    else
      @get('currentPlan.totalUsers') - 1
  ).property('currentPlan.totalUsers')


