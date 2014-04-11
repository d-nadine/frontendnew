Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users']
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isPersisting: Ember.computed.alias 'parentController.isPersisting'
  currentPlan: Ember.computed.alias 'currentUser.account.billingInfo.subscription'
  subscriptionEnded: Ember.computed.alias 'currentUser.account.billingInfo.subscriptionEnded'
  activeCard: Ember.computed.alias 'parentController.activeCard'
  isTrial: Ember.computed.alias 'parentController.account.isTrial'

  isCurrent: ( ->
    return false if @get('currentUser.account.subscriptionInvalid')
    return if @get('parentController.isPersisting')
    return false if @get('isTrial')
    @get('parentController.currentPlan') == @get('model')
  ).property('parentController.currentPlan', 'model', 'isPersisting')

  showCancel: Ember.computed 'isCurrent', 'subscriptionEnded', ->
    return false if @get('currentPlan') == 'basic'
    return false if @get('isTrial')
    return false if @get('subscriptionEnded')
    @get('isCurrent')

  totalUsers: ( ->
    if @get('isBasic')
      1
    else
      @get('model.totalUsers') - 1
  ).property('isBasic', 'model.totalUsers')

  isBasic: Ember.computed.equal 'model.planId', 'basic'

  exceededUsers: Ember.computed 'model.totalUsers', 'users.[]', ->
    @get('totalUsers') < @get('users.length')


  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isPersisting', 'activeCard', 'users.[]', ->
    return true if @get('isPersisting')
    return true unless @get('activeCard')
    return false if @get('isTrial')
    return true if @get('model.planId') == 'basic' && @get('currentPlan.planId') != 'basic'

    return false if @get('currentPlan') == 'basic'

    return true if @get('isCurrent')

    @get('totalUsers') < @get('users.length')
