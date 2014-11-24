Radium.SubscriptionMixin = Ember.Mixin.create
  needs: ['subscriptionPlans']
  subscriptionPlans: Ember.computed.oneWay 'controllers.subscriptionPlans'

  activeSubscriptions: Ember.computed 'subscriptionPlans.[]', ->
    @get('subscriptionPlans').reject((plan) =>
      (plan.get('disabled') && plan != @get('currentPlan')) || /_year$/g.test(plan.get('planId'))
    ).sort((left, right) ->
      Ember.compare(left.get('displayOrder'), right.get('displayOrder'))
    )

  currentPlan: Ember.computed 'subscriptionPlans.[]', 'account.billing.subscriptionPlan', ->
    subscription = @get('account.billing.subscriptionPlan')
    return unless subscription

    subscriptionPlans = @get('subscriptionPlans')
    return unless subscriptionPlans.get('length')

    plan = @get('subscriptionPlans').find (plan) -> plan.get('planId') == subscription.get('planId')

    plan

  totalUsers: Ember.computed 'currentPlan.totalUsers', ->
    return unless @get('currentPlan')

    Ember.assert "Subscription plan should have totalUsers", @get('currentPlan.totalUsers')

    totalUsers = @get('currentPlan.totalUsers')
    if totalUsers == 1 then 1 else totalUsers - 1
