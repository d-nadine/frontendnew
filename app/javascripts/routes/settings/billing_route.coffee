Radium.SettingsBillingRoute = Radium.Route.extend
  actions:
    confirmCancelSubscription: ->
      @render 'billing/cancellation_confirmation',
        into: 'application'
        outlet: 'modal'
        controller: @controllerFor 'settingsBilling'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

  model: ->
    accountController = @controllerFor('account')

    return unless accountController.get('gatewaySetup')

    billing = accountController.get('billing')

    hash =
      card: Radium.ActiveCard.find accountController.get('id')

    if billing.get('hasSubscription')
      hash.subscription = Radium.ActiveSubscription.find accountController.get('id')

    Ember.RSVP.hash(hash)
      .catch (error) ->
        if hash.card.get('inErrorState')  || error.constructor == Radium.ActiveCard
          delete hash.card

        if hash.subscription.get('inErrorState') || error.constructor == Radium.ActiveSubscription
          delete hash.subscription

        return hash

  setupController: (controller, model) ->
    billing = @controllerFor('account').get('model.billing')
    controller.set 'model', billing

    return unless model

    if model.hasOwnProperty('card') && !model.card?.get('inErrorState')
      controller.set 'activeCard', model.card

    if model.hasOwnProperty('subscriptionPlan') && !model?.subscriptionPlan?.get('inErrorState')
      controller.set 'activeSubscription', model.subscriptionPlan

  deactivate: ->
    @_super.apply this, arguments
    @controller.set('showBillingForm', false)
