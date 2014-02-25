Radium.AddContactsComponent = Ember.Component.extend
  actions:
    addSelection: (lookup) ->
      refs = @get('parent.contacts').mapProperty('id')
      refs.push(lookup.get('id'))

      @set('parent.contactRefs', refs)

      @get('store').commit()

    removeSelection: (contact) ->
      refs = @get('parent.contacts').mapProperty('id')

      refs.removeObject(contact.get('id'))

      @set('parent.contactRefs', refs)

      @get('store').commit()

  store: Ember.computed ->
    @get('container').lookup('store:main')

  isEditable: true

  contactsPicker: Radium.AsyncAutocompleteView.extend
    actions:
      addSelection: (item) ->
        @get('controller').send('addSelection', item)

      removeSelection: (item) ->
        @get('controller').send('removeSelection', item)

    sourceBinding: 'controller.targetObject.model.contacts'
    isEditable: Ember.computed.alias 'controller.isEditable'
    queryParameters: (query) ->
      term: query
      email_only: false
      scopes: ['contact']

    filterResults: (item) ->
      parent = @get('targetObject.parent')
      return if parent.get('contact') == item.get('person')

      not parent.get('contacts').mapProperty('id').contains(item.id)
