require 'mixins/controllers/bulk_action_controller_mixin'

Radium.PipelineIndexController = Radium.ObjectController.extend Radium.BulkActionControllerMixin,
  needs: ['workflowGroupItem']
  filteredDeals: null

  selectedGroup: Ember.computed.alias 'controllers.workflowGroupItem.selectedGroup'

  title: 'Pipeline'

  currentDeals: ( ->
    return unless @get('workflowDeals.length')

    @get('workflowDeals').filter (deal) =>
      deal.get('status') == @get('selectedGroup')
  ).property('selectedGroup', 'workflowDeals.[]')

  checkedContent: ( ->
    @get('workflowDeals').filterProperty 'isChecked'
  ).property('currentDeals.@each.isChecked')

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  groups: ( ->
    return [] unless @get('workflowGroups.length')

    debugger

    Ember.ArrayProxy.create
      content: @get('workflowGroups')
  ).property('workflowGroups')

  total: Ember.reduceComputed "workflowDeals.@each.{status,value}",
    initialValue: 0
    addedItem: (accumulatedValue, item, changeMeta, instanceMeta) ->
      if item.get('status') == 'lost'
        return accumulatedValue

      accumulatedValue + item.get('value')

    removedItem: (accumulatedValue, item, changeMeta, instanceMeta) ->
      if item.get('status') == 'lost'
        return accumulatedValue

      accumulatedValue - item.get('value')
