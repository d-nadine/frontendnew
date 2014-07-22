Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users']
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isPersisting: Ember.computed.alias 'parentController.isPersisting'
  currentPlan: Ember.computed.alias 'currentUser.account.billing.subscription'
  subscriptionEnded: Ember.computed.alias 'currentUser.account.billing.subscriptionEnded'
  activeCard: Ember.computed.alias 'parentController.activeCard'
  isTrial: Ember.computed.alias 'parentController.account.billing.isTrial'
  isUnlimited: Ember.computed.alias 'currentUser.account.isUnlimited'

  isCurrent: Ember.computed 'parentController.currentPlan', 'model', 'isPersisting', ->
    return false if @get('currentUser.subscriptionInvalid')
    return if @get('parentController.isPersisting')
    @get('parentController.currentPlan') == @get('model')

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
    return true if @get('isUnlimited')
    @get('totalUsers') < @get('users.length')

  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isPersisting', 'activeCard', 'users.[]', ->
    return true if @get('isPersisting')

    return true if @get('isBasic')

    return true if @get('isCurrent')

    @get('totalUsers') < @get('users.length')

  isCurrentAndisTrial: Ember.computed.and 'isCurrent', 'isTrial'
