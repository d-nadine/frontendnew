require 'lib/radium/groupable'

NegotiatingGroup = Ember.ArrayProxy.extend
  title: (->
    @get('firstObject.status')
  ).property('firstObject.status')

Radium.PipelineController = Em.ArrayController.extend Radium.SettingsMixin, Radium.Groupable,
  negotiatingStatuses: Ember.computed.alias('controllers.settings.negotiatingStatuses')

  leads: (->
    Radium.Contact.filter (contact) ->
      contact.get('status') is 'lead'
  ).property()

  # FIXME: replace with FilterableArray
  negotiatingDeals: (->
    model = @get 'model'
    return unless model

    statuses = @get 'negotiatingStatuses'

    model.filter (deal) ->
      statuses.indexOf(deal.get('status')) != -1
  ).property('model', 'negotiatingStatuses')

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
    return unless @get('model')

    @get('model').filter (deal) ->
      deal.get('status') is 'closed'
  ).property('model', 'model.length')

  lost: (->
    return unless @get('model')

    @get('model').filter (contact) ->
      contact.get('status') is 'lost'
  ).property('model', 'model.length')
