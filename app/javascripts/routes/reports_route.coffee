Radium.ReportsRoute = Ember.Route.extend
  model: ->
    # deals = []
    $.getJSON 'http://localhost:9292/deals/report', (json) ->
      console.log(json['deals'])
      json['deals']
      # deals = [
      #   {date: new Date(2014, 1, 4), total: 1412.00, user: "Paul", status: "lead", company: "Acme"}
      #   {date: new Date(2014, 5, 27), total: 1202.11, user: "Michael", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 6, 12), total: 412.00, user: "Paul", status: "lead", company: "Acme"}
      #   {date: new Date(2014, 6, 22), total: 402.00, user: "John", status: "open", company: "Billings Corp"}
      #   {date: new Date(2014, 7, 4), total: 412.00, user: "Paul", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 9, 4), total: 0, user: "Paul", status: "lead", company: "Billings Corp"}
      #   {date: new Date(2014, 10, 4), total: 0, user: "Paul", status: "lead", company: "Coffees"}
      #   {date: new Date(2014, 10, 1), total: 412.00, user: "Pete", status: "lost", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 11, 9), total: 3200.00, user: "John", status: "closed", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 6, 22), total: 402.00, user: "John", status: "open", company: "Billings Corp"}
      #   {date: new Date(2014, 7, 4), total: 412.00, user: "Paul", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 9, 4), total: 0, user: "Paul", status: "lead", company: "Billings Corp"}
      #   {date: new Date(2014, 10, 4), total: 0, user: "Paul", status: "lead", company: "Coffees"}
      #   {date: new Date(2014, 10, 1), total: 412.00, user: "Pete", status: "lost", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 11, 9), total: 3200.00, user: "John", status: "closed", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 6, 22), total: 402.00, user: "John", status: "open", company: "Billings Corp"}
      #   {date: new Date(2014, 7, 4), total: 412.00, user: "Paul", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 9, 4), total: 0, user: "Paul", status: "lead", company: "Billings Corp"}
      #   {date: new Date(2014, 10, 4), total: 0, user: "Paul", status: "lead", company: "Coffees"}
      #   {date: new Date(2014, 10, 1), total: 412.00, user: "Pete", status: "lost", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 11, 9), total: 3200.00, user: "John", status: "closed", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 6, 22), total: 402.00, user: "John", status: "open", company: "Billings Corp"}
      #   {date: new Date(2014, 7, 4), total: 412.00, user: "Paul", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 9, 4), total: 0, user: "Paul", status: "lead", company: "Billings Corp"}
      #   {date: new Date(2014, 10, 4), total: 0, user: "Paul", status: "lead", company: "Coffees"}
      #   {date: new Date(2014, 10, 1), total: 412.00, user: "Pete", status: "lost", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 11, 9), total: 3200.00, user: "John", status: "closed", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 6, 22), total: 402.00, user: "John", status: "open", company: "Billings Corp"}
      #   {date: new Date(2014, 7, 4), total: 412.00, user: "Paul", status: "closed", company: "Acme"}
      #   {date: new Date(2014, 9, 4), total: 0, user: "Paul", status: "lead", company: "Billings Corp"}
      #   {date: new Date(2014, 10, 4), total: 0, user: "Paul", status: "lead", company: "Coffees"}
      #   {date: new Date(2014, 10, 1), total: 412.00, user: "Pete", status: "lost", company: "Dundler Mifflen"}
      #   {date: new Date(2014, 11, 9), total: 3200.00, user: "John", status: "closed", company: "Dundler Mifflen"}
      # ]
    # deals

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.setupCrossfilter()