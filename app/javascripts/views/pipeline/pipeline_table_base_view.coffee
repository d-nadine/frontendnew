Radium.PipelineTableBaseView = Em.View.extend
  contentBinding: 'controller.pagedContent'
  checkLead: Em.Checkbox.extend
    contentBinding: Ember.Binding.oneWay 'parentView.content'
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @get('content').toggleProperty('isChecked')
