Radium.UserDealTotalsItemController = Radium.ObjectController.extend
  deals: Ember.computed.alias 'parentController.deals'

  dealsTotal: Ember.computed 'model', 'deals.[]', ->
    return 0 unless @get('model')
    return 0 unless @get('deals.length')

    @get('deals').filter((deal) =>
      deal.get('status') == @get('model')
    ).length

  dealsValue: Ember.computed 'deals.@each.status', ->
    return 0 unless @get('model')
    return 0 unless @get('deals.length')

    @get('deals').filter((deal) =>
      deal.get('status') == @get('model')
    ).reduce((preVal, item) ->
      preVal + item.get('value')
    , 0, 'value')
