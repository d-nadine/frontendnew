require 'mixins/controllers/bulk_action_controller_mixin'

Radium.PipelineIndexController = Radium.ObjectController.extend Radium.BulkActionControllerMixin,
  Radium.BulkActionControllerMixin,

  needs: ['workflowGroupItem']
  filteredDeals: null
  searchText: null

  filterStartDate: null
  filterEndDate: null

  arrangedDealsLength: 0

  checkedContent: Ember.computed.filterBy 'workflowDeals', 'isChecked', true

  selectedGroup: Ember.computed.alias 'controllers.workflowGroupItem.selectedGroup'

  title: 'Active Pipeline'

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

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
