Radium.AddressBookResultItemController = Radium.ObjectController.extend
  check: (item) ->
    item.toggleProperty 'isChecked'

  contacts: ( ->
    return @get('model.contacts') unless @get('isTag')

    Radium.Contact.all().filter (contact) => contact.get('tags').contains @get('model')
  ).property('model')

  isCompany: ( ->
    @get('model') instanceof Radium.Company
  ).property('model')

  isContact: ( ->
    @get('model') instanceof Radium.Contact
  ).property('model')

  isTag: ( ->
    @get('model') instanceof Radium.Tag
  ).property('model')

  openDeals: ( ->
    return if @get('isTag')
    return @companyOpenDeals() if @get('isCompany')

    @get('deals').filter (deal) ->
      deal.status != 'closed' || deals.status != 'lost'
  ).property('deals.[]')

  leads: ( ->
    return Ember.A() unless @get('isCompany')

    @get('contacts').filterProperty 'isLead'
  ).property('contacts.[]')

  truncatedContacts: ( ->
    @get('contacts').toArray().sort((left, right) ->
      Ember.compare(left.get('name'), right.get('name'))).slice(0, 3)
  ).property('contacts.[]')

  hasMoreContacts: ( ->
    contacts = @get('contacts.length')

    return unless contacts

    contacts > @get('truncatedContacts.length')
  ).property('contacts.[]', 'truncatedContacts')

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

  membersText: ( ->
    contacts = @get('contacts.length')

    return unless contacts

    group = if @get('isTag') then "Member" else "Employee"

    if contacts == 1 then "1 #{group}" else "#{contacts} #{group}s"
  ).property('openDeals.[]')
