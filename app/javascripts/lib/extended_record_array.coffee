# This is class similar to RecordArray, with a small addition,
# it can keep records from any kind of record.
#
# It keeps array of [type, clientId] pairs under the hood
Radium.ExtendedRecordArray = Ember.ArrayProxy.extend
  content: null
  store: null

  init: ->
    @set('content', Ember.A())
    @_super.apply(this, arguments)

  objectAtContent: (index) ->
    content = @get('content')
    element = content.objectAt(index)
    if element?
      [type, clientId] = element
      store = @get('store')

      if clientId?
        store.findByClientId(type, clientId)

  replaceContent: (idx, amt, objects) ->
    objects = Ember.A(objects).map (o) ->
      type = o.constructor
      clientId = o.get('clientId')
      [type, clientId]

    @_super(idx, amt, objects)
