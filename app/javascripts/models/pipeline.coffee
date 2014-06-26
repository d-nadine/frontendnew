require 'lib/radium/groupable'
require 'lib/radium/groupable_with_defaults'

WorkflowGroup = Ember.ArrayProxy.extend
  title: Ember.computed 'firstObject.status', ->
    @get('firstObject.status')

# FIXME: this should be an Ember.Object. The PipelineController
# has to each into content since properties on an array proxy
# don't work. Also there's never a case where the content is
# not going to be Deal.all
Radium.Pipeline = Ember.ArrayProxy.extend Radium.GroupableWithDefaults,
  content: []
  settings: null
  workflowStates: Ember.computed 'settings.model', 'settings.dealStates.[]', ->
    statuses = @get('settings.dealStates')

    statuses.forEach (state) =>
      unless @get(state)
        Ember.defineProperty this, state, Ember.computed "#{state}.[]", ->
          Radium.Deal.filter (deal) ->
            deal.get('status') == state

    statuses

  workflowDeals: Ember.computed 'workflowStates.[]', 'workflowDeals.[]', 'workflowDeals.@each.status', ->
    statuses = @get 'workflowStates'

    return unless statuses

    Radium.Deal.filter (deal) ->
      statuses.indexOf(deal.get('status')) != -1

  workflowGroups: Ember.computed 'workflowDeals.[]', ->
    deals = @get 'workflowDeals'
    return unless deals

    states = @get('settings.dealStates')

    @group deals, states

  activeDeals: Ember.computed 'workflowDeals.[]', ->
    return @get("workflowDeals").filter (deal) ->
      return deal.get("status").toLowerCase() not in ["closed", "lost"]

  groupType: WorkflowGroup

  groupBy: (deal) ->
    deal.get('status')

  workflowTotal: Ember.computed 'workflowDeals.length', ->
    @get 'workflowDeals.length'

  closed: Ember.computed 'closed.[]', ->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'closed'

  lost: Ember.computed 'lost.[]', ->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'lost'

  unpublished: Ember.computed 'unpublished.[]', ->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'unpublished'
