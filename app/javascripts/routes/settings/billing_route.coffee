Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    accountController = @controllerFor('account')

    return unless accountController.get('gatewaySetup')

    Ember.RSVP.hash
      card: Radium.ActiveCard.find accountController.get('id')
      subscription: Radium.ActiveSubscription.find accountController.get('id')

  setupController: (controller, model) ->
    billingInfo = @controllerFor('account').get('model.billingInfo')
    controller.set 'model', billingInfo

    return unless model

    controller.set 'activeCard', model.card
    controller.set 'activeSubscription', model.subscription
