Radium.AddressBookResultItemController = Radium.ObjectController.extend
  check: (item) ->
    item.toggleProperty 'isChecked'

  isCompany: ( ->
    @get('model') instanceof Radium.Company
  ).property('model')

  isContact: ( ->
    @get('model') instanceof Radium.Contact
  ).property('model')

  openDeals: ( ->
    return @companyOpenDeals() if @get('isCompany')
    @get('deals').filter (deal) ->
      deal.status != 'closed' || deals.status != 'lost'
  ).property('deals.[]')

  leads: ( ->
    return Ember.A() unless @get('isCompany')

    @get('contacts').filterProperty 'isLead'
  ).property('contacts.[]')

  companyOpenDeals: ->
    openDeals = Ember.A()

    @get('contacts').forEach (contact) ->
      openDeals.pushObjects contact.get('deals').filter((deal) ->
        deal.status != 'closed' || deals.status != 'lost').toArray()

    openDeals.uniq()

  openDealsText: ( ->
    openDeals = @get('openDeals.length')

    return unless openDeals

    if openDeals == 1 then "1 Open Deal" else "#{openDeals} Open Deals"
  ).property('openDeals.[]')

  leadsText: ( ->
    leads = @get('leads.length')

    return unless leads

    if leads == 1 then "1 Lead" else "#{leads} Leads"
  ).property('openDeals.[]')
