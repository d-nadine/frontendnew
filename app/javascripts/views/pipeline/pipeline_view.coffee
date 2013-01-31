Radium.PipelineView = Em.View.extend
  layoutName: 'layouts/single_column'
  templateName: 'pipeline/pipeline'
  checkContent: Em.Checkbox.extend
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @get('content').toggleProperty('isChecked')
