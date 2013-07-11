Radium.PipelineWorkflowRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: (params) ->
    params.pipeline_state

  setupController: (controller, state) ->
    pipeline = @modelFor('pipeline')

    unless pipeline.get state
      Ember.defineProperty pipeline, state, Ember.computed( ->
        Radium.Deal.filter (deal) ->
          deal.get('status') == state
      ).property("#{state}.[]")

    controller = @controllerFor('pipelineWorkflowDeals')
    controller.set('title', state)
    controller.set('model', pipeline.get(state))
    controller.set 'showHeader', true

  renderTemplate: ->
    @render 'pipeline/workflow_deals',
      into: 'pipeline'
