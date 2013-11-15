Radium.ReportsRoute = Ember.Route.extend
  model: ->
    [
      {date: new Date(2013, 5, 27), total: 1202.11, user: "Michael", status: "closed"}
      {date: new Date(2013, 6, 12), total: 412.00, user: "Paul", status: "lead"}
      {date: new Date(2013, 6, 22), total: 402.00, user: "John", status: "open"}
      {date: new Date(2013, 7, 4), total: 412.00, user: "Paul", status: "closed"}
      {date: new Date(2013, 9, 4), total: 0, user: "Paul", status: "lead"}
      {date: new Date(2013, 10, 4), total: 0, user: "Paul", status: "lead"}
      {date: new Date(2013, 10, 1), total: 412.00, user: "Pete", status: "lost"}
    ]

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.setupCrossfilter()