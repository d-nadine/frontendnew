Radium.CompanyMainComponent = Ember.Component.extend Radium.ScrollableMixin,
  actions:
    displayDeals: ->
      # FIXME: display company deals

      false

    deleteCompany: ->
      @sendAction "deleteCompany", @get('company')

      false

  classNames: ['main-content']

  nameValidations: ['required']

  groupedDeals: Ember.arrayComputed 'company.contacts', 'deals.@each.status', {
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

        return unless contact.get('company') == @get('company')

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

  deals: Ember.computed 'company', 'company.deals.[]', ->
    Radium.Deal.filter (deal) ->
      true

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      about: @get('company')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'company', 'tomorrow', ->
    reference: @get('company')
    finishBy: null
    user: @get('currentUser')

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'company', ->
    reference: @get('company')
    user: @get('currentUser')

  loadedPages: [1]
