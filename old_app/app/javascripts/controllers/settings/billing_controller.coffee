require 'controllers/settings/subscriptions_mixin'

Radium.SettingsBillingController = Radium.ObjectController.extend BufferedProxy,
  Radium.SubscriptionMixin,
  Ember.Evented,
  actions:
    changeCountry: (country) ->
      @set 'country', country.key

      false

    confirmCancelSubscription: ->
      @set "showDeleteConfirmation", true

      false

    cancelSubscription: ->
      @set "showDeleteConfirmation", false

      @set 'isPersisting', true

      billing = @get('model')

      billing.set('subscriptionPlan', null)

      activeSubscription = @get('activeSubscription')

      unless activeSubscription
        return @flashMessenger "There is no active subscription please contact support."

      billing.save().then =>
        billing.reload()

        finish = =>
          @set 'isPersisting', false

          if endDate = @get('activeSubscription.subscriptionEndDate')?.toHumanFormat()
            @flashMessenger.success "Your subscription has been cancelled and will expire on the #{endDate}."
          else
            @flashMessenger.success "Your subscription has been cancelled."

        unless activeSubscription
          return finish()

        activeSubscription.reload()

        activeSubscription.one 'didReload', ->
          return finish()

      @addErrorEvents(billing)

      @applyBufferedChanges()

      @get('store').commit()

    update: ->
      @set 'isPersisting', true

      unless @hasBufferedChanges
        @send 'flashSuccess', 'Your billing information has been updated.'
        return

      @applyBufferedChanges()

      @set 'isSubmitted', true

      return unless @get('isValid')

      billing = @get('model')

      billing.save().then (result) =>
        @set('token', null) if @get('token')
        @set 'isPersisting', false
        @send 'flashSuccess', 'Your billing information has been updated.'

        billing.reload()

        Radium.ActiveCard.find(@get('account.id')).then (card) =>
          @set 'activeCard', card

        window.Intercom('update', subscription_plan: billing.get('subscriptionPlan.name'))

      @addErrorEvents(billing)

      @get('store').commit()

    cancel: ->
      @discardBufferedChanges()

    updateSubscription: (subscriptionPlan, yearly, yearOption) ->
      isTrial = @get('isTrial')
      isBasic = @get('isBasic')
      trialDaysLeft = @get('account.trialDaysLeft')
      currentPlan = @get('account.billing.subscriptionPlan')
      isDifferentPlan = currentPlan.get('id').toString() != subscriptionPlan.get('id').toString()

      if @get('isBasic') && subscriptionPlan.get('totalUsers') > 1
        return @changeTrialPlan(subscriptionPlan, Radium.CreateTrialPlan)

      if isTrial && trialDaysLeft > 0 && isDifferentPlan
        return @changeTrialPlan(subscriptionPlan, Radium.UpdateTrialPlan)

      unless activeCard = @get('activeCard')
        @flashMessenger.error "Please enter your cred card details."
        return

      if yearly
        subscriptionPlan = yearOption

      @set 'isPersisting', true

      unless @get('activeCard')
        @send 'flashError', 'You need to add your credit card details before you upgrade.'
        return

      billing = @get('model')

      Ember.assert "The gatway identifier is not set", billing.get('gatewayIdentifier')

      billing.set('subscriptionPlan', subscriptionPlan)
      billing.set('gatewaySet', true)

      @applyBufferedChanges()

      billing.save().then =>
        @send 'flashSuccess', "You are now on the #{subscriptionPlan.get('name')} plan, reloading in 5 seconds..."
        setInterval((-> window.location.reload()), 3000)

      @addErrorEvents(billing)

      @get('store').commit()

  needs: ['users', 'account']
  account: Ember.computed.oneWay 'controllers.account.model'
  unlimited: Ember.computed.oneWay 'account.unlimited'
  isNewCard: false
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

  changeTrialPlan: (subscriptionPlan, planType) ->
    @set 'isPersisting', true

    billing = @get('model')
    currentUser = @get('currentUser')

    trial = planType.createRecord
              user: currentUser
              account: currentUser.get('account')
              subscriptionPlan: subscriptionPlan

    trial.save().then =>
      @set 'isPersisting', false

      @send "flashSuccess", "The trial #{subscriptionPlan.get('name')} has been set."
      currentUser.reload()
      billing.reload()

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
      return 'days'

    if daysLeft < 2 then "day" else "days"

  country: Ember.computed 'model.country', (key, value) ->
    if arguments.length == 2 && value != undefined
      @set 'model.country', value
      return value
    else
      unless @get('model.country')
        "USA"
      else
        @get('model.country')

  phone: Ember.computed 'model.phone', 'currentUser.phone', (key, value) ->
    if arguments.length == 2 && value != undefined
      @set 'model.phone', value
    else
      unless @get('model.phone')
        @get('currentUser.phone')
      else
        @get('model.phone')
