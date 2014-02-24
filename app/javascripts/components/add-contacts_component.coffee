Radium.AddContactsComponent = Ember.Component.extend
  actions:
    addSelection: (lookup) ->
      @get('parent.contacts').addObject(lookup.get('person'))

      @get('store').commit()

    removeSelection: (contact) ->
      @get('parent.contacts').removeObject(lookup.get('person'))

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
      @get('targetObject.parent.contact') != item
