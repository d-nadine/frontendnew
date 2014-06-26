require 'controllers/settings/subscriptions_mixin'

Radium.SettingsBillingController = Radium.ObjectController.extend BufferedProxy,
  Radium.SubscriptionMixin,
  Ember.Evented,
  actions:
    updateBilling: ->
      return if @get('gatewaySet')

      @set 'showBillingForm', true

    changeBilling: ->
      @toggleProperty('showBillingForm')
      false

    cancelSubscription: ->
      @set 'showBillingForm', false

      @set 'isPersisting', true

      billing = @get('model')

      billing.set('subscription', null)

      billing.one 'didUpdate', =>
        activeSubscription = @get('activeSubscription')
        activeSubscription.reload()

        activeSubscription.one 'didReload', =>
          @set 'isPersisting', false

          @send 'flashSuccess', "Your subscription has been cancelled and will expire on the #{@get('activeSubscription.subscriptionEndDate').toHumanFormat()}"

      @addErrorEvents(account)

      @applyBufferedChanges()

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

      billing = @get('model')

      # billingInfo = account.get('billingInfo')

      # FIXME: Hack to stop a PUT on embedded object
      # account.set('billingInfo.organisation', model.get('organisation'))
      # account.set('billingInfo.token', model.get('token'))
      # account.set('billingInfo.billingEmail', model.get('billingEmail'))
      # account.set('billingInfo.reference', model.get('reference'))
      # account.set('billingInfo.phone', model.get('phone'))
      # account.set('billingInfo.vat', model.get('vat'))
      # account.set('billingInfo.country', model.get('country'))

      billing.one 'didUpdate', (result) =>
        # @get('model').transitionTo("loaded.saved")
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

    updateSubscription: (subscription) ->
      unless activeCard = @get('activeCard')
        @set 'showBillingForm', true
        return

      @set 'showBillingForm', false
      @set 'isPersisting', true

      unless @get('account.gatewaySetup')
        @send 'flashError', 'You need to add your credit card details before you upgrade.'
        return

      billing = @get('model')

      Ember.assert "Current subscription is available for selection.", billing.get('subscription') != subscription

      billing.set('subscription', subscription)

      @applyBufferedChanges()

      billing.one 'didUpdate', =>
        if subscription != 'basic'
          Radium.ActiveSubscription.find(@get('controllers.account.id')).then (activeSubscription) =>
            @set 'activeSubscription', activeSubscription

        @set 'isPersisting', false
        @send 'flashSuccess', "You are now on the #{subscription.name} plan"

      @addErrorEvents(billing)

      @get('store').commit()

  needs: ['settings', 'users', 'account', 'countries']
  account: Ember.computed.alias 'controllers.account.model'
  isUnlimited: Ember.computed.alias 'account.isUnlimited'
  isNewCard: false
  showBillingForm: false
  activeCard: null
  isPersisting: false

  addErrorEvents: (billing) ->
    billing.one 'becameError', (result) =>
      @set 'isPersisting', false
      @send 'flashError', "An error has occurred and your subscription cannot be updated"
      @discardBufferedChanges()
      @get('model').transitionTo("loaded.saved")

    billing.one 'becameInvalid', (result) =>
      @set 'isPersisting', false
      @send 'flashError', result
      @discardBufferedChanges()
      model = @get('model')
      model.get("transaction").rollback()
      model.transitionTo("loaded.saved")
      @trigger 'cardError'

  isValid: Ember.computed 'organisation', 'billingEmail', 'isSubmitted', ->
    return true unless @get('isSubmitted')
    return if Ember.isEmpty(@get('organisation'))
    email = @get('billingEmail')
    return if Ember.isEmpty(email)
    return unless @emailIsValid email
    true

  hasGatewayAccount: Ember.computed.bool 'gatewayIdentifier'

  showNextPaymentDate: Ember.computed 'hasGatewayAccount', 'activeSubscription', 'activeSubscription.nextDueDate', 'billingInfo.subscriptionEnded', ->
    return false unless @get('hasGatewayAccount')
    return false if @get('billingInfo.subscriptionEnded')
    !!@get('activeSubscription.nextDueDate')

  trialUnit: Ember.computed 'account.trialDaysLeft', ->
    unless daysLeft = @get("account.trialDaysLeft")
      return

    if daysLeft < 2 then "day" else "days"

  country: Ember.computed 'model.country', (key, value) ->
    if arguments.length == 2 && value != undefined
      @set 'model.country', value
    else
      unless @get('model.country')
        @get('controllers.countries.firstObject')
      else
        @get('model.country')
