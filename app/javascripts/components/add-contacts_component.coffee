Radium.AddContactsComponent = Ember.Component.extend
  actions:
    addContact: (lookup) ->
      @get('parent.contactRefs').createRecord
        contact: lookup.get("person")

      @get('store').commit()

      false

    removeContact: (contact) ->
      ref = @get('parent.contactRefs').find (ref) -> ref.get('contact.id') == contact.get('id')

      return unless ref

      @get('parent.contactRefs').removeObject(ref)

      @get('store').commit()

      false

  isEditable: true

  queryParameters: (query) ->
    term: query
    email_only: false
    scopes: ['contact']

  filterResults: (item) ->
    parent = @get('parent')
    return if parent.get('contact') == item.get('person')

    not parent.get('contacts').mapProperty('id').contains(item.id)

  _setup: Ember.on 'init', ->
    @_super.apply this, arguments

    @filterResults = @filterResults.bind(this)
