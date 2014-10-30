Radium.PipelineWorkflowRoute = Radium.PipelineBaseRoute.extend Radium.BulkActionEmailEventsMixin,
  Radium.ClearCheckedMixin,
  model: (params) ->
    params.pipeline_state

  setupController: (controller, state) ->
    @_super.apply this, arguments
    pipeline = @modelFor('pipeline')

    prop = state.dasherize().toLowerCase()

    unless pipeline.get prop
      Ember.defineProperty pipeline, prop, Ember.computed "#{prop}", ->
        Radium.Deal.filter (deal) ->
          deal.get('status') == state

    controller = @controllerFor('pipelineWorkflowDeals')
    controller.set('title', state)
    controller.set('model', pipeline.get(prop))
    controller.set 'showHeader', true
    @clearChecked()

  renderTemplate: ->
    @render 'pipeline/workflow_deals',
      into: 'pipeline'

  deactivate: ->
    @clearChecked()
