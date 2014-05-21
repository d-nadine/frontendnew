Radium.SubscriptionMixin = Ember.Mixin.create
  needs: ['subscriptionPlans']
  subscriptionPlans: Ember.computed.oneWay 'controllers.subscriptionPlans'

  activeSubscriptions: Ember.computed 'subscriptionPlans.[]', ->
    @get('subscriptionPlans').reject (plan) =>
      (plan.get('disabled') && plan != @get('currentPlan'))

  currentPlan: Ember.computed 'subscriptionPlans.[]', 'account.billingInfo.subscription', ->
    subscription = @get('account.billingInfo.subscription')
    return unless subscription

    subscriptionPlans = @get('subscriptionPlans')
    return unless subscriptionPlans.get('length')

    @get('subscriptionPlans').find (plan) => plan.get('planId') == subscription

  totalUsers: Ember.computed 'currentPlan.totalUsers', ->
    if @get('currentPlan.planId') == 'basic'
      1
    else
      @get('currentPlan.totalUsers') - 1
