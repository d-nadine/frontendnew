Radium.PipelineLeadView = Em.View.extend
  templateName: 'radium/pipeline/pipeline_lead'
  checkMailItem: Em.Checkbox.extend
    contentBinding: Ember.Binding.oneWay 'parentView.content'
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('content.isChecked', not @get('content.isChecked'))
