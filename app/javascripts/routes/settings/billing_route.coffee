Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    Radium.SubscriptionPlan.find({})

  # FIXME: currentPlan needs set on account in API
  # setupController: (controller, models) ->
  #   models.forEach (item) =>
  #     item.set('isCurrent', true) if item.get('id') is settings.get('currentPlan')
