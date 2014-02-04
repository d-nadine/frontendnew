Radium.CompanyController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  actions:
    displayDeals: ->
      deals = Ember.A()
      @get('groupedDeals').forEach (group) => deals.pushObjects group.get('deals')

      @get('controllers.pipelineOpendeals').set('filteredDeals', deals)

      @transitionToRoute 'pipeline.opendeals'

  needs: ['users', 'accountSettings',  'tags', 'companies', 'countries', 'leadStatuses', 'pipelineOpendeals']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'

  # FIXME: How do we determine this?
  isEditable: true

  maxContactsStatus: ( ->
    contacts = @get('contacts')

    return unless contacts.get('length')

    maxStatus = -1

    statuses = @get('leadStatuses').map (status) ->
                status.value

    contacts.forEach (contact) ->
      index = statuses.indexOf contact.get('status')

      if index > maxStatus
        maxStatus = index

    maxStatus = if maxStatus == -1 then 0 else maxStatus

    @get('leadStatuses').objectAt(maxStatus).name
  ).property('contacts.[]')

  membersText: Ember.computed 'contacts.[]', ->
    "View all #{@get('contacts.length')} contacts."

  truncatedContacts: ( ->
    @get('contacts').toArray().sort((left, right) ->
      Ember.compare(left.get('name'), right.get('name'))).slice(0, 3)
  ).property('contacts.[]', 'model')

  hasMoreContacts: ( ->
    contacts = @get('contacts.length')

    return unless contacts

    contacts > @get('truncatedContacts.length')
  ).property('contacts.[]', 'truncatedContacts')

  groupedDeals: Ember.arrayComputed 'contacts', 'deals.@each.status', {
    initialValue: []
    initialize: (array, changeMeta, instanceMeta) ->
      array.pushObject(Ember.Object.create(key: 'open', name: 'Open Deals', count: 0, value: 0, deals: Ember.A()))
      array.pushObject(Ember.Object.create(key: 'closed', name: 'Closed Deals', count: 0, value: 0, deals: Ember.A()))
      array.pushObject(Ember.Object.create(key: 'lost', name: 'Lost Deals', count: 0, value: 0, deals: Ember.A()))

    addedItem: (array, deal, changeMeta, instanceMeta) ->
      contact = deal.get('contact')

      observer = =>
        return unless contact.get('isLoaded')
        contact.removeObserver 'isLoaded', observer

        return unless contact.get('company') == @get('model')

        status = deal.get('status')

        group = if ['closed', 'lost'].contains status
                  array.findBy 'key', status
                else
                  array.findBy 'key', 'open'

        group.incrementProperty 'count'
        group.incrementProperty 'value', deal.get('value')
        group.get('deals').pushObject deal

      return unless contact

      unless contact.get('isLoaded')
        contact.addObserver('isLoaded', observer)
      else
        observer()

      array

    removedItem: (array, deal, changeMeta, instanceMeta) ->
      group = array.find (group) -> group.get('deals').contains deal

      return unless group

      group.decrementProperty 'count'
      group.decrementProperty 'value', deal.get('value')
      group.get('deals').removeObject deal

      array
  }

  deals: ( ->
    Radium.Deal.filter (deal) =>
      true
  ).property('model', 'deals.[]')
