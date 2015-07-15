require 'routes/deal_new_base_route'

Radium.DealsFromContactRoute = Radium.DealNewBaseRoute.extend
  model: (params) ->
    Radium.Contact.find(params.contact_id)

  setupController: (controller, model) ->
    controller = @controllerFor 'dealsNew'
    @_super.call this, controller, model
    controller.set 'contact', model
    controller.set 'model.user', @get('currentUser')

  renderTemplate: ->
    @render 'deals.new',
      controller: 'dealsNew'
