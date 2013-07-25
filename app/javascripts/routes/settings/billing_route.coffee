Radium.SettingsBillingRoute = Radium.Route.extend
  model: ->
    planA = Ember.Object.create
      id: 1
      title: "Plan A"
      price: "9.99"
      totalUsers: 5

    planB = Ember.Object.create
      id: 2
      title: "Plan B"
      price: "12.99"
      totalUsers: 20

    planC = Ember.Object.create
      id: 3
      title: "Plan C"
      price: "19.99"
      totalUsers: 100

    models = Ember.A([planA, planB, planC])

  # FIXME: currentPlan needs set on account in API
  # setupController: (controller, models) ->
  #   models.forEach (item) =>
  #     item.set('isCurrent', true) if item.get('id') is settings.get('currentPlan')
