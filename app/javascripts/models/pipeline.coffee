require 'lib/radium/groupable'
require 'lib/radium/groupable_with_defaults'

NegotiatingGroup = Ember.ArrayProxy.extend
  title: (->
    @get('firstObject.status')
  ).property('firstObject.status')

# FIXME: this should be an Ember.Object. The PipelineController
# has to each into content since properties on an array proxy
# don't work. Also there's never a case where the content is
# not going to be Deal.all
Radium.Pipeline = Ember.ArrayProxy.extend Radium.GroupableWithDefaults,
  content: []
  settings: null
  negotiatingStates: ( ->
    @get('settings.negotiatingStates')
  ).property('settings.model', 'settings.negotiatingStates')

  negotiatingDeals: (->
    statuses = @get 'negotiatingStates'

    return unless statuses

    Radium.Deal.filter (deal) ->
      statuses.indexOf(deal.get('status')) != -1
  ).property('negotiatingStates.[]', 'negotiatingDeals.[]', 'negotiatingDeals.@each.status')

  negotiatingGroups: (->
    #FIXME: Potential memory leak.  Nothing getting destroyed
    deals = @get 'negotiatingDeals'
    return unless deals

    states = @get('settings.negotiatingStates')

    @group deals, states
  ).property('negotiatingDeals.[]')

  groupType: NegotiatingGroup

  groupBy: (deal) ->
    deal.get('status').replace(/\W+/, "_")

  negotiatingTotal: (->
    @get 'negotiatingDeals.length'
  ).property('negotiatingDeals.length')

  closed: (->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'closed'
  ).property('closed.[]')

  lost: (->
    Radium.Deal.filter (deal) ->
      deal.get('status') == 'lost'
  ).property('lost.[]')

  leads: (->
    Radium.Contact.filter (contact) -> contact.get('isLead')
  ).property()
