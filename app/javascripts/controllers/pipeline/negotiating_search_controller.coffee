require 'radium/controllers/pipeline/period_search_controller'
Radium.PipelineNegotiatingSearchController = Radium.PeriodSearchController.extend
  needs: ['pipelineNegotiating']
  dealsBinding: 'controllers.pipelineNegotiating.content'
