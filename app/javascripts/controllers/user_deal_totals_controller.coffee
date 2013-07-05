Radium.UserDealTotalsItemController = Radium.ObjectController.extend
  deals: Ember.computed.alias 'target.target.deals'

  dealsTotal: ( ->
    return 0 unless @get('model')
    return 0 unless @get('deals.length')

    @get('deals').filter((deal) =>
      deal.get('status') == @get('model')
    ).length
  ).property('model', 'deals.[]')

  dealsValue: ( ->
    return 0 unless @get('model')
    return 0 unless @get('deals.length')

    @get('deals').filter((deal) =>
      deal.get('status') == @get('model')
    )
    .reduce((preVal, item) ->
      preVal + item.get('value')
    , 0, 'value')
  ).property('checklist.@each.isFinished')


