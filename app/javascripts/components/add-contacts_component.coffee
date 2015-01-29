Radium.AddContactsComponent = Ember.Component.extend
  actions:
    addSelection: (lookup) ->
      @get('parent.contactRefs').createRecord
        contact: lookup.get("person")

      @get('store').commit()

    removeSelection: (contact) ->
      ref = @get('parent.contactRefs').find (ref) -> ref.get('contact.id') == contact.get('id')

      return unless ref

      @get('parent.contactRefs').removeObject(ref)

      @get('store').commit()

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
