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

    Ember.ArrayProxy.create
      content: @get('workflowGroups')
  ).property('workflowGroups')

  total: (->
    workflowDeals = @get('workflowDeals')

    return 0 if workflowDeals.get('length') == 0

    workflowDeals.reduce(((value, item) ->
      if item.get('status') == 'lost'
        return value

      value + item.get('value')
    ), 0)
  ).property('workflowDeals.[]')


