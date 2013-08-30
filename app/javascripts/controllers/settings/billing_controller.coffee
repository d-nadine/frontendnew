Radium.SettingsBillingController = Radium.ObjectController.extend BufferedProxy,
  needs: ['settings', 'users', 'account', 'subscriptionPlans', 'countries']
  subscriptionPlans: Ember.computed.alias 'controllers.subscriptionPlans'
  account: Ember.computed.alias 'controllers.account.model'
  isNewCard: false

  changeBilling: ->
    @set('isNewCard', true)

  cancel: ->
    @set('isNewCard', false)

  isValid: ( ->
    return true unless @get('isSubmitted')
    return if Ember.isEmpty(@get('organisation'))
    return if Ember.isEmpty(@get('billingEmail'))
    true
  ).property('organisation', 'billingEmail', 'isSubmitted')

  currentPlan: ( ->
    subscription = @get('account.billingInfo.subscription')
    return unless subscription

    subscriptionPlans = @get('subscriptionPlans')
    return unless subscriptionPlans.get('length')

    @get('subscriptionPlans').find (plan) => plan.get('name') == subscription
  ).property('subscriptionPlans.[]', 'account.billingInfo.subscription')

  totalUsers: ( ->
    unless @get('currentPlan.totalUsers')
      5
    else
      @get('currentPlan.totalUsers')
  ).property('currentPlan.totalUsers')

  hasGatewayAccount: ( ->
    @get('account.billingInfo.gatewayIdentifier')
  ).property('account.billingInfo.gatewayIdentifier')

  activeCard: ( ->
    Radium.ActiveCard.find @get('account.id')
  ).property('account.billingInfo.gatewayIdentifier', 'hasGatewayAccount')

  country: ( (key, value) ->
    if arguments.length == 2 && value != undefined
      @set 'model.country', value
    else
      unless @get('model.country')
        @get('controllers.countries.firstObject')
      else
        @get('model.country')
  ).property('model.country')

  update: ->
    unless @hasBufferedChanges
      @send 'flashSuccess', 'Your billing information has been updated.'
      return

    @applyBufferedChanges()

    @set 'isSubmitted', true

    return unless @get('isValid')

    model = @get('model')

    account = @get('account')

    billingInfo = account.get('billingInfo')

    # FIXME: Hack to stop a PUT on embedded object
    account.set('billingInfo.organisation', model.get('organisation'))
    account.set('billingInfo.token', model.get('token'))
    account.set('billingInfo.billingEmail', model.get('billingEmail'))
    account.set('billingInfo.reference', model.get('reference'))
    account.set('billingInfo.phone', model.get('phone'))
    account.set('billingInfo.vat', model.get('vat'))
    account.set('billingInfo.country', model.get('country'))

    account.one 'didUpdate', (result) =>
      @send 'flashSuccess', 'Your billing information has been updated.'

    account.one 'becameError', (result) =>
      @send 'flashError', "An error happened and you billing information could not be updated"
      result.reset() 

    account.one 'becameInvalid', (result) =>
      @send 'flashError', result
      result.reset()

    @get('account.transaction').commit()

  cancel: ->
    @discardBufferedChanges()

  updateBilling: ->
    @set('isUpdatingBilling', true)

    Ember.run.later(=>
      @setProperties
        isUpdatingBilling: false
        isNewCard: false
    , 1500)

  updateSubscription: (subscription) ->
    model = @get('model')

    account = @get('account')

    billingInfo = account.get('billingInfo')

    account.set('billingInfo.subscription', subscription)

    account.one 'didUpdate', =>
      @send 'flashSuccess', "You are now on the #{subscription} plan"

    account.one 'becameError', (result) =>
      @send 'flashError', "An error has occurred and your subscription cannot be updated"
      result.reset() 

    account.one 'becameInvalid', (result) =>
      @send 'flashError', result
      result.reset()

    @get('store').commit()
