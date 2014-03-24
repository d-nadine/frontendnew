Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users']
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isPersisting: Ember.computed.alias 'parentController.isPersisting'
  currentPlan: Ember.computed.alias 'currentUser.account.billingInfo.subscription'
  subscriptionEnded: Ember.computed.alias 'currentUser.account.billingInfo.subscriptionEnded'
  activeCard: Ember.computed.alias 'parentController.activeCard'

  isCurrent: ( ->
    return if @get('parentController.isPersisting')
    @get('parentController.currentPlan') == @get('model')
  ).property('parentController.currentPlan', 'model', 'isPersisting')

  showCancel: Ember.computed 'isCurrent', 'subscriptionEnded', ->
    return false if @get('currentPlan') == 'basic'
    return false if @get('subscriptionEnded')
    @get('isCurrent')

  totalUsers: ( ->
    @get('model.totalUsers') - 1
  ).property('model.totalUsers')

  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isPersisting', 'activeCard', 'users.[]', ->
    return true if @get('isPersisting')
    return true unless @get('activeCard')
    # return true if @get('subscriptionEnded')

    return false if @get('currentPlan') == 'basic'

    return true if @get('isCurrent')

    @get('totalUsers') < @get('users.length')
