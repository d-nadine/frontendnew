Radium.PipelineView = Em.View.extend
  layoutName: 'layouts/single_column'
  templateName: 'pipeline/pipeline'
  checkContent: Em.Checkbox.extend
    contentBinding: Ember.Binding.oneWay 'parentView.content'
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @get('content').toggleProperty('isChecked')
  remainingDealsLink: Radium.RemainingDealsLinkView.extend()
