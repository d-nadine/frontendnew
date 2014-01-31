require 'routes/deal_new_base_route'

Radium.DealsFromCompanyRoute = Radium.DealNewBaseRoute.extend
  model: (params) ->
    Radium.Company.find(params.company_id)

  setupController: (controller, model) ->
    controller = @controllerFor 'dealsNew'
    @_super.call this, controller, model
    controller.set 'company', model
    controller.set 'model.user', @controllerFor('currentUser').get('model')

  renderTemplate: ->
    @render 'deals.new',
      controller: 'dealsNew'
