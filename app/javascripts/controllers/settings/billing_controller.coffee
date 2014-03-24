Radium.SettingsBillingController = Radium.ObjectController.extend BufferedProxy,
  actions:
    changeBilling: ->
      @set('showBillingForm', true)

    cancelSubscription: ->
      @set 'isPersisting', true

      model = @get('model')

      account = @get('account')

      account.set('billingInfo.subscription', null)

      account.one 'didUpdate', =>
        activeSubscription = @get('activeSubscription')
        activeSubscription.reload()

        activeSubscription.one 'didReload', =>
          @set 'isPersisting', false

          @send 'flashSuccess', "Your subscription has been cancelled and will expire on the #{@get('activeSubscription.subscriptionEndDate').toHumanFormat()}"

      @addErrorEvents(account)

      @get('store').commit()

      @send 'close'

    update: ->
      @set 'isPersisting', true

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
        @get('model').transitionTo("loaded.saved")
        @set('token', null) if @get('token')
        @set 'isPersisting', false
        @send 'flashSuccess', 'Your billing information has been updated.'

        Radium.ActiveCard.find(@get('controllers.account.id')).then (card) =>
          @set 'activeCard', card

      @addErrorEvents(account)

      @get('store').commit()

    cancel: ->
      @discardBufferedChanges()
      @set 'showBillingForm', false

    updateBilling: ->
      @set('isUpdatingBilling', true)

      Ember.run.later(=>
        @setProperties
          isUpdatingBilling: false
          isNewCard: false
      , 1500)

    updateSubscription: (subscription) ->
      @set 'isPersisting', true

      model = @get('model')

      account = @get('account')

      unless @get('account.gatewaySetup')
        @send 'flashError', 'You need to add your credit card details before you upgrade.'
        return

      billingInfo = account.get('billingInfo')

      account.set('billingInfo.subscription', subscription)

      account.one 'didUpdate', =>
        Radium.ActiveSubscription.find(@get('controllers.account.id')).then (activeSubscription) =>
          @set 'activeSubscription', activeSubscription

        @set 'isPersisting', false
        @send 'flashSuccess', "You are now on the #{subscription} plan"

      @addErrorEvents(account)

      @get('store').commit()

  needs: ['settings', 'users', 'account', 'subscriptionPlans', 'countries']
  subscriptionPlans: Ember.computed.alias 'controllers.subscriptionPlans'
  account: Ember.computed.alias 'controllers.account.model'
  isNewCard: false
  showBillingForm: false
  activeCard: null
  isPersisting: false

  addErrorEvents: (account) ->
    account.one 'becameError', (result) =>
      @set 'isPersisting', false
      @send 'flashError', "An error has occurred and your subscription cannot be updated"
      account.reset()
      @get('model').transitionTo("loaded.saved")

    account.one 'becameInvalid', (result) =>
      @set 'isPersisting', false
      @send 'flashError', result
      account.reset()
      @get('model').transitionTo("loaded.saved")

  isValid: ( ->
    return true unless @get('isSubmitted')
    return if Ember.isEmpty(@get('organisation'))
    email = @get('billingEmail')
    return if Ember.isEmpty(email)
    return unless @emailIsValid email
    true
  ).property('organisation', 'billingEmail', 'isSubmitted')

  currentPlan: ( ->
    subscription = @get('account.billingInfo.subscription')
    return unless subscription

    subscriptionPlans = @get('subscriptionPlans')
    return unless subscriptionPlans.get('length')

    @get('subscriptionPlans').find (plan) => plan.get('name') == subscription
  ).property('subscriptionPlans.[]', 'account.billingInfo.subscription')

  validPlans: Ember.computed.filter 'subscriptionPlans', (plan) ->
    plan.get('name') != 'basic'

  totalUsers: ( ->
    if @get('currentPlan.name') == 'basic'
      1
    else
      @get('currentPlan.totalUsers') - 1
  ).property('currentPlan.totalUsers')

  hasGatewayAccount: ( ->
    @get('account.billingInfo.gatewayIdentifier')
  ).property('account.billingInfo.gatewayIdentifier')

  showNextPaymentDate: Ember.computed 'hasGatewayAccount', 'activeSubscription', 'activeSubscription.nextDueDate', 'billingInfo.subscriptionEnded', ->
    return false unless @get('hasGatewayAccount')
    return false if @get('billingInfo.subscriptionEnded')
    !!@get('activeSubscription.nextDueDate')

  country: ( (key, value) ->
    if arguments.length == 2 && value != undefined
      @set 'model.country', value
    else
      unless @get('model.country')
        @get('controllers.countries.firstObject')
      else
        @get('model.country')
  ).property('model.country')
