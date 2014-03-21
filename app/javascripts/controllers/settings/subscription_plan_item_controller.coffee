Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  needs: ['users']
  hasGatewayAccount: Ember.computed.alias 'parentController.hasGatewayAccount'
  users: Ember.computed.alias 'controllers.users'
  isSaving: Ember.computed.alias 'parentController.isSaving'

  notSelectable: ( ->
    return true if @get('isCurrent')
    !@get('hasGatewayAccount')
  ).property('hasGatewayAccount', 'isCurrent')

  isCurrent: ( ->
    return false unless @get('isPaidAccount')
    @get('parentController.currentPlan') == @get('model')
  ).property('parentController.currentPlan', 'model')

  totalUsers: ( ->
    @get('model.totalUsers') - 1
  ).property('model.totalUsers')

  notViable: Ember.computed 'isCurrent', 'totalUsers', 'isSaving', 'users.[]', ->
    return true if @get('isSaving')

    return false if @get('isCurrent')

    @get('totalUsers') < @get('users.length')
