require 'routes/deal_new_base_route'

Radium.DealsFromUserRoute = Radium.DealNewBaseRoute.extend
  model: (params) ->
    Radium.User.find(params.user_id)

  setupController: (controller, model) ->
    controller = @controllerFor 'dealsNew'
    @_super.call this, controller, model
    controller.set 'user', model

  renderTemplate: ->
    @render 'deals.new',
      controller: 'dealsNew'
