Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    @controllerFor('account').get('model.billingInfo')

  # FIXME: currentPlan needs set on account in API
  # setupController: (controller, models) ->
  #   models.forEach (item) =>
  #     item.set('isCurrent', true) if item.get('id') is settings.get('currentPlan')
