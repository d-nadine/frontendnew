require 'routes/deal_new_base_route'

Radium.DealsNewRoute = Radium.DealNewBaseRoute.extend
  setupController: (controller, model) ->
    @_super.call this, controller, model
    controller.set 'model.user', @controllerFor('currentUser').get('model')

  deactivate: ->
    @controller.set 'isSubmitted', false
    @controller.get('model').reset()
