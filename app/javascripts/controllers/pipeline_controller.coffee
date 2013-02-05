Radium.PipelineController = Em.Controller.extend Radium.AccountMixin,
  leads: (->
    Radium.Contact.filter((contact) ->
      contact.get('status') is 'lead'
    )
  ).property()

  customStatuses: ( ->
    return unless @get('model')

    statuses = Em.ArrayProxy.create
                content: []

    @get('settings.pipelineStatuses').forEach (status, index) =>
      customStatus = Ember.Object.create
        index: index
        status: status.get('status')
        deals: @get('model').filter (deal) -> deal.get('status') == status.get('status')

      statuses.pushObject(customStatus)

    statuses
  ).property('settings', 'settings.pipelineStatuses', 'model')


  customStatusesTotal: ( ->
    total = 0

    @get('customStatuses').forEach (item) ->
      total += item.get('deals.length')

    total
  ).property('customStatus', 'customStatus.length')

  closed: (->
    return unless @get('model')

    @get('model').filter((deal) ->
      deal.get('status') is 'closed'
    )
  ).property('model', 'model.length')

  lost: (->
    return unless @get('model')

    @get('model').filter((contact) ->
      contact.get('status') is 'lost'
    )
  ).property('model', 'model.length')
