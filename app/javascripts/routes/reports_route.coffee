Radium.ReportsRoute = Ember.Route.extend
  model: ->
    base_url = @get('store._adapter.url')
    $.getJSON("#{base_url}/deals/report").then (json) ->
      json['deals'].forEach (deal) ->
        deal.date = new Date(deal.date)
        deal.total = Number(deal.total)
        deal.status = deal.status.toLowerCase()
      json['deals']

  setupController: (controller, model) ->
    controller.set 'content', model
    controller.setupCrossfilter()