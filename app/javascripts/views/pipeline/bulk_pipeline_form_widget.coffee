require 'radium/views/forms/bulk_action_form_widget'
Radium.BulkPipelineFormWidget = Radium.BulkActionFormWidget.extend
  init: ->
    @_super.apply this, arguments

  additionalText: ( ->
    "(#{@get('selection.length')})"
  ).property('selection', 'selection.length')
