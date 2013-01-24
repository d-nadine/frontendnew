Radium.LeadSearchController = Em.ArrayController.extend
  contentBinding: 'pipelineTableController.visibleContent'
  showLeadSearch: (event) ->
    contact = event.context
