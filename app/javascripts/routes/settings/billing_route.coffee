Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    @controllerFor('account').get('model.billingInfo')
