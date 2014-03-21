Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    accountController = @controllerFor('account')

    return unless accountController.get('gatewaySetup')

    Radium.ActiveCard.find accountController.get('id')

  setupController: (controller, model) ->
    billingInfo = @controllerFor('account').get('model.billingInfo')
    controller.set 'model', billingInfo
    controller.set 'activeCard', model
