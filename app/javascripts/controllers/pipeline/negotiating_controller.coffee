require 'controllers/pipeline/deals_controller'

Radium.PipelineNegotiatingController = Radium.PipelineDealsController.extend
  needs: ['pipeline']

  statuses: ( ->
    @get('controllers.pipeline.customStatuses')
  ).property('controllers.pipeline.customStatuses')

