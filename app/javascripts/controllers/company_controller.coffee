require "mixins/persist_tags_mixin"

Radium.CompanyController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.PersistTagsMixin,
  Radium.CanFollowMixin,
  actions:
    displayDeals: ->
      deals = Ember.A()
      @get('groupedDeals').forEach (group) -> deals.pushObjects group.get('deals')

      @get('controllers.pipelineOpendeals').set('filteredDeals', deals)

      @transitionToRoute 'pipeline.opendeals'

  needs: ['users', 'accountSettings',  'tags', 'companies', 'countries', 'contactStatuses', 'pipelineOpendeals']
  contactStatuses: Ember.computed.alias 'controllers.contactStatuses'
  loadedPages: [1]

  # FIXME: How do we determine this?
  isEditable: true

  membersText: Ember.computed 'contacts.[]', ->
    "View all #{@get('contacts.length')} contacts."

  truncatedContacts: Ember.computed 'contacts.[]', 'model', ->
    @get('contacts').toArray().sort((left, right) ->
      Ember.compare(left.get('name'), right.get('name'))).slice(0, 3)

  hasMoreContacts: Ember.computed 'contacts.[]', 'truncatedContacts', ->
    contacts = @get('contacts.length')

    return unless contacts

    contacts > @get('truncatedContacts.length')

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

  deals: Ember.computed 'model', 'deals.[]', ->
    Radium.Deal.filter (deal) ->
      true
