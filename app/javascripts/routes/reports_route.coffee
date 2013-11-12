Radium.ReportsRoute = Ember.Route.extend
  model: ->
    [
      {date: new Date(2013, 11, 27), total: 1202.11, user: "Michael"}
      {date: new Date(2013, 11, 22), total: 402.00, user: "John"}
      {date: new Date(2013, 11, 12), total: 412.00, user: "Paul"}
      {date: new Date(2013, 11, 4), total: 412.00, user: "Paul"}
      {date: new Date(2013, 7, 1), total: 412.00, user: "Pete"}
    ]

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.setupCrossfilter()