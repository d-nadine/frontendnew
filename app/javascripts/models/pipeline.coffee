require 'lib/radium/groupable'

NegotiatingGroup = Ember.ArrayProxy.extend
  title: (->
    @get('firstObject.status')
  ).property('firstObject.status')

# FIXME: this should be an Ember.Object. The PipelineController 
# has to each into content since properties on an array proxy 
# don't work. Also there's never a case where the content is
# not going to be Deal.all
Radium.Pipeline = Ember.ArrayProxy.extend Radium.Groupable,
  content: []
  settings: null
  negotiatingStatusesBinding: 'settings.negotiatingStatuses'

  # FIXME: replace with FilterableArray
  negotiatingDeals: (->
    statuses = @get 'negotiatingStatuses'

    return unless statuses

    content = @get 'content'
    return unless content

    content.filter (deal) ->
      statuses.indexOf(deal.get('status')) != -1
  ).property('content', 'negotiatingStatuses', 'negotiatingStatuses.length')

  negotiatingGroups: (->
    deals = @get 'negotiatingDeals'
    return unless deals

    @group deals
  ).property('negotiatingDeals')

  groupType: NegotiatingGroup

  groupBy: (deal) ->
    deal.get('status').replace(/\W+/, "_")

  negotiatingTotal: (->
    @get 'negotiatingDeals.length'
  ).property('negotiatingDeals.length')

  closed: (->
    return unless @get('content')

    @get('content').filter (deal) ->
      deal.get('status') is 'closed'
  ).property('content', 'content.length')

  lost: (->
    return unless @get('content')

    @get('content').filter (contact) ->
      contact.get('status') is 'lost'
  ).property('content', 'content.length')

  leads: (->
    Radium.Contact.filter (contact) -> contact.get('isLead')
  ).property()


