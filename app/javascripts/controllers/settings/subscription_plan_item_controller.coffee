Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users', 'subscriptionPlans']
  subscriptionPlans: Ember.computed.oneWay 'controllers.subscriptionPlans'

  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isPersisting: Ember.computed.alias 'parentController.isPersisting'
  currentPlan: Ember.computed.alias 'currentUser.account.billing.subscriptionPlan'
  subscriptionEnded: Ember.computed.alias 'currentUser.account.billing.subscriptionEnded'
  activeCard: Ember.computed.alias 'parentController.activeCard'
  isTrial: Ember.computed.alias 'parentController.account.billing.isTrial'
  unlimited: Ember.computed.alias 'currentUser.account.unlimited'

  isCurrent: Ember.computed 'parentController.currentPlan', 'model', 'isPersisting', 'yearOption', ->
    return false if @get('currentUser.subscriptionInvalid')
    return if @get('parentController.isPersisting')
    currentPlan = @get('parentController.currentPlan')

    currentPlan == @get('model') || @get('currentPlanIsYearly')

  showCancel: Ember.computed 'isCurrent', 'subscriptionEnded', ->
    return false if @get('isBasic')
    return false if @get('isTrial')
    return false if @get('subscriptionEnded')
    @get('isCurrent')

  totalUsers: Ember.computed 'isBasic', 'model.totalUsers', ->
    totalUsers = @get('model.totalUsers')
    if totalUsers == 1 then 1 else totalUsers - 1

  isBasic: Ember.computed.equal 'model.planId', 'basic'
  isSolo: Ember.computed.equal 'model.planId', 'solo'

  exceededUsers: Ember.computed 'model.totalUsers', 'users.[]', ->
    return true if @get('unlimited')
    @get('totalUsers') < @get('users.length')

  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isPersisting', 'activeCard', 'users.[]', ->
    return true if @get('isPersisting')

    return true if @get('isBasic')

    return true if @get('isCurrent')

    @get('totalUsers') < @get('users.length')

  isCurrentAndisTrial: Ember.computed.and 'isCurrent', 'isTrial'

  yearOption: Ember.computed 'subscriptionPlans.[]', 'model', ->
    return if !@get('model') || !@get('subscriptionPlans.length')

    currentPlanId = @get('model.planId')

    @get('subscriptionPlans').find (plan) -> plan.get('planId') == "#{currentPlanId}_year"

  upgradeText: Ember.computed 'isCurrent', 'model', 'yearOption', ->
    return "Your Plan" if @get('isCurrent')

    "Upgrade"

  showYearOption: Ember.computed 'yearOption', 'isCurrent', 'exceededUsers', ->
    return false if @get('exceededUsers')

    @get('yearOption') && not @get('isCurrent')

  currentPlanIsYearly: Ember.computed 'yearOption', 'parentController', ->
    @get('yearOption') == @get('parentController.currentPlan')

  pricingText: Ember.computed 'model', 'isCurrent', 'currentPlanIsYearly', 'yearOption', 'yearly', ->
    return "Free" if @get('isBasic')

    currentPlan = @get('parentController.currentPlan')
    model = @get('model')
    yearOption = @get('yearOption')

    ret = if @get('isCurrent')
      "#{accounting.formatMoney(currentPlan.get('amount'))}/#{currentPlan.get('interval')}"
    else
      if @get('yearly')
        "#{accounting.formatMoney(yearOption.get('amount'))}/#{yearOption.get('interval')}"
      else
        "#{accounting.formatMoney(model.get('amount'))}/#{model.get('interval')}"

    ret

  yearly: false