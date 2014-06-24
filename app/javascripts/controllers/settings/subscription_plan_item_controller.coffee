Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users']
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isPersisting: Ember.computed.alias 'parentController.isPersisting'
  currentPlan: Ember.computed.alias 'currentUser.account.billingInfo.subscription'
  subscriptionEnded: Ember.computed.alias 'currentUser.account.billingInfo.subscriptionEnded'
  activeCard: Ember.computed.alias 'parentController.activeCard'
  isTrial: Ember.computed.alias 'parentController.account.isTrial'
  isUnlimited: Ember.computed.alias 'currentUser.account.isUnlimited'

  isCurrent: Ember.computed 'parentController.currentPlan', 'model', 'isPersisting', ->
    return false if @get('currentUser.account.subscriptionInvalid')
    return if @get('parentController.isPersisting')
    @get('parentController.currentPlan') == @get('model')

  showCancel: Ember.computed 'isCurrent', 'subscriptionEnded', ->
    return false if @get('currentPlan') == 'basic'
    return false if @get('isTrial')
    return false if @get('subscriptionEnded')
    @get('isCurrent')

  totalUsers: Ember.computed 'isBasic', 'model.totalUsers', ->
    if @get('isBasic') || @get('isSolo')
      1
    else
      @get('model.totalUsers') - 1

  isBasic: Ember.computed.equal 'model.planId', 'basic'
  isSolo: Ember.computed.equal 'model.planId', 'solo'

  exceededUsers: Ember.computed 'model.totalUsers', 'users.[]', ->
    return true if @get('isUnlimited')
    @get('totalUsers') < @get('users.length')

  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isPersisting', 'activeCard', 'users.[]', ->
    return true if @get('isPersisting')
    return true if @get('model.planId') == 'basic' && @get('currentPlan.planId') != 'basic'

    return false if @get('currentPlan') == 'basic'

    return true if @get('isCurrent')

    @get('totalUsers') < @get('users.length')
