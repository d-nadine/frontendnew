require 'radium/controllers/pipeline/period_search_controller'
Radium.NegotiatingSearchController = Radium.PeriodSearchController.extend
  needs: ['pipelineNegotiating']
  dealsBinding: 'controllers.pipelineNegotiating.checkedContent'

