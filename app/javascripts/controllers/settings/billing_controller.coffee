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

      billing.set('subscriptionPlan', null)

      activeSubscription = @get('activeSubscription')

      Ember.assert "There is no active subscription to canel", activeSubscription

      billing.one 'didUpdate', =>
        activeSubscription.reload()

        activeSubscription.one 'didReload', =>
          @set 'isPersisting', false

          @send 'flashSuccess', "Your subscription has been cancelled and will expire on the #{@get('activeSubscription.subscriptionEndDate').toHumanFormat()}"

        billing.reload()

      @addErrorEvents(billing)

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

      billing.one 'didUpdate', (result) =>
        @set('token', null) if @get('token')
        @set 'isPersisting', false
        @send 'flashSuccess', 'Your billing information has been updated.'

        billing.reload()

        Radium.ActiveCard.find(@get('account.id')).then (card) =>
          @set 'activeCard', card

      @addErrorEvents(billing)

      @get('store').commit()

    cancel: ->
      @discardBufferedChanges()
      @set 'showBillingForm', false

    updateSubscription: (subscriptionPlan, yearly, yearOption) ->
      unless activeCard = @get('activeCard')
        @set 'showBillingForm', true
        return

      if yearly
        subscriptionPlan = yearOption

      @set 'showBillingForm', false
      @set 'isPersisting', true

      unless @get('activeCard')
        @send 'flashError', 'You need to add your credit card details before you upgrade.'
        return

      billing = @get('model')

      Ember.assert "The gatway identifier is not set", billing.get('gatewayIdentifier')

      billing.set('subscriptionPlan', subscriptionPlan)
      billing.set('gatewaySet', true)

      @applyBufferedChanges()

      billing.one 'didUpdate', =>
        @send 'flashSuccess', "You are now on the #{subscriptionPlan.get('name')} plan, reloading in 5 seconds..."
        setInterval((-> window.location.reload()), 3000)

      @addErrorEvents(billing)

      @get('store').commit()

  needs: ['users', 'account', 'countries']
  account: Ember.computed.alias 'controllers.account.model'
  unlimited: Ember.computed.alias 'account.unlimited'
  isNewCard: false
  showBillingForm: false
  activeCard: null
  isPersisting: false

  addErrorEvents: (billing) ->
    billing.one 'becameError', (result) =>
      @set 'isPersisting', false
      @send 'flashError', "An error has occurred and your subscription cannot be updated"
      @get('model').transitionTo("loaded.saved")

    billing.one 'becameInvalid', (result) =>
      @set 'isPersisting', false
      @send 'flashError', result
      model = @get('model')
      model.get("transaction").rollback()
      model.transitionTo("loaded.saved")
      @trigger 'cardError'

  isValid: Ember.computed 'organisation', 'billingEmail', 'organisation.length', 'billingEmail.length', 'isSubmitted', ->
    return true unless @get('isSubmitted')
    return if Ember.isEmpty(@get('organisation'))
    email = @get('billingEmail')
    return if Ember.isEmpty(email)
    return unless @emailIsValid email
    true

  hasGatewayAccount: Ember.computed.bool 'activeCard'

  showNextPaymentDate: Ember.computed 'hasGatewayAccount', 'activeSubscription', 'activeSubscription.nextDueDate', 'subscriptionEnded', ->
    return false unless @get('hasGatewayAccount')
    return false if @get('subscriptionEnded')
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


