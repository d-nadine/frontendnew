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

  totalUsers: ( ->
    unless @get('currentPlan.totalUsers')
      5
    else
      @get('currentPlan.totalUsers')
  ).property('currentPlan.totalUsers')

  activeCard: ( ->
    return unless @get('gatewayIdentifier')
    Radium.ActiveCard.find @get('account.id')
  ).property('gatewayIdentifier')

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
    return unless @hasBufferedChanges

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

    account.one 'didUpdate', =>
      @send 'flashSuccess', 'Your billing information has been updated.'

    account.one 'becameError', (result) =>
      @send 'flashError', result
      result.reset() 

    account.one 'becameInvalid', (result) =>
      @send 'flashError', result
      result.reset()

    @get('store').commit()

  cancel: ->
    @discardBufferedChanges()

  # currentPlan: (->
  #   @get('content').findProperty('isCurrent', true)
  # ).property('@each.isCurrent')

  updateBilling: ->
    @set('isUpdatingBilling', true)

    Ember.run.later(=>
      @setProperties
        isUpdatingBilling: false
        isNewCard: false
    , 1500)

  upgradePlan: (model) ->
    @get('content').setEach('isCurrent', false)
    model.set('isCurrent', true)
    @set('controllers.settings.currentPlan', model.get('id'))
