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

    billingInfo = accountController.get('billingInfo')

    hash =
      card: Radium.ActiveCard.find accountController.get('id')

    if ['bronze', 'silver', 'gold'].contains billingInfo.get('subscription')
      hash.subscription = Radium.ActiveSubscription.find accountController.get('id')

    Ember.RSVP.hash hash

  setupController: (controller, model) ->
    billingInfo = @controllerFor('account').get('model.billingInfo')
    controller.set 'model', billingInfo

    return unless model

    controller.set 'activeCard', model.card

    if model.hasOwnProperty('subscription')
      controller.set 'activeSubscription', model.subscription
