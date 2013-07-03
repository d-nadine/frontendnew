require 'views/pipeline/pipeline_base_view'
Radium.PipelineWorkflowView = Radium.PipelineViewBase.extend
  showResults: true
  toggleResultsTable: (evt) ->
    @$('.table.totals').slideToggle('medium')
    @toggleProperty 'showResults'
