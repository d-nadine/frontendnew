require 'mixins/controllers/bulk_action_controller_mixin'
require 'mixins/user_combobox_props'

Radium.PipelineIndexController = Radium.ObjectController.extend Radium.BulkActionControllerMixin,
  Radium.BulkActionControllerMixin,
  Radium.UserComboboxProps,

  needs: ['workflowGroupItem', "pipeline", "pipelineWorkflowDeals"]
  filteredDeals: null
  searchText: Ember.computed.alias 'controllers.pipeline.searchText'
  filterStartDate: Ember.computed.alias 'controllers.pipeline.filterStartDate'
  filterEndDate: Ember.computed.alias 'controllers.pipeline.filterEndDate'
  showPastDateRange: Ember.computed.alias 'controllers.pipeline.showPastDateRange'
  showFutureDateRange: Ember.computed.alias 'controllers.pipeline.showFutureDateRange'

  arrangedDealsLength: 0

  checkedContent: Ember.computed.filterBy 'workflowDeals', 'isChecked', true

  selectedGroup: Ember.computed.alias 'controllers.workflowGroupItem.selectedGroup'

  title: 'Active Pipeline'

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  total: Ember.reduceComputed "workflowDeals.@each.{status,value}",
    initialValue: 0
    addedItem: (accumulatedValue, item, changeMeta, instanceMeta) ->
      if item.get('status') in ['lost', 'closed'] || item.get('isUnPublished')
        return accumulatedValue

      accumulatedValue + item.get('value')

    removedItem: (accumulatedValue, item, changeMeta, instanceMeta) ->
      if item.get('status') in ['lost', 'closed'] || item.get('isUnPublished')
        return accumulatedValue

      accumulatedValue - item.get('value')
