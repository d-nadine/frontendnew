require 'radium/views/pipeline/remaining_deals_link_view'
Radium.PipelineTableBaseView = Em.View.extend
  contentBinding: 'controller.visibleContent'
  checkLead: Em.Checkbox.extend
    contentBinding: Ember.Binding.oneWay 'parentView.content'
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @get('content').toggleProperty('isChecked')
  remainingDealsLink: Radium.RemainingDealsLinkView.extend()
