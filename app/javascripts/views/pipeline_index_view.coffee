require 'views/pipeline/pipeline_base_view'

Radium.PipelineIndexView = Radium.PipelineViewBase.extend
  showResults: true
  toggleResultsTable: (evt) ->
    @$('.table.totals').slideToggle('medium')
    @toggleProperty 'showResults'
