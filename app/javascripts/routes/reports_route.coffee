Radium.ReportsRoute = Ember.Route.extend
  model: ->
    [
      {date: "2013-11-07T16:17:54Z", total: 1202.11, user: "Michael"}
      {date: "2013-11-07T16:20:19Z", total: 402.00, user: "John"}
      {date: "2013-11-07T16:20:19Z", total: 412.00, user: "Paul"}
      {date: "2013-11-07T16:20:19Z", total: 412.00, user: "Paul"}
    ]

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.setupCrossfilter()