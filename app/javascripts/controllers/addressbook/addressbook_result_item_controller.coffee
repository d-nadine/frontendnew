Radium.AddressBookResultItemController = Radium.ObjectController.extend
  check: (item) ->
    item.toggleProperty 'isChecked'

  openDeals: ( ->
    @get('deals').filter (deal) ->
      deal.status != 'closed' || deals.status != 'lost'
  ).property('deals.[]')

  openDealsText: ( ->
    openDeals = @get('openDeals.length')

    return unless openDeals

    if openDeals == 1 then "1 Open Deal" else "#{openDeals} Open Deals"
  ).property('openDeals.[]')
