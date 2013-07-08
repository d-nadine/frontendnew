Radium.PipelineUserDealsRoute = Radium.Route.extend
  model: (params) ->
    Radium.User.find(params.user_id)
  setupController: (controller, user) ->
    model = Radium.Deal.all().filter (deal) -> deal.get('user') == user
    controller.set('model', model)

  renderTemplate: ->
    @render 'pipeline.opendeals',
      controller: 'pipelineUserDeals'
