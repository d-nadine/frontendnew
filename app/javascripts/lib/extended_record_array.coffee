# This is class similar to RecordArray, with a small addition,
# it can keep records with any type.
#
# It keeps array of [type, clientId] pairs under the hood
Radium.ExtendedRecordArray = Ember.ArrayProxy.extend
  content: null
  store: null

  objectAtContent: (index) ->
    content = @get('content')
    element = content.objectAt(index)
    if element?
      [type, clientId] = element
      store = @get('store')

      if clientId?
        store.findByClientId(type, clientId)

  replaceContent: (idx, amt, objects) ->
    [idx, amt, objects] = @prepareForReplace(idx, amt, objects)

    @_super(idx, amt, objects)

  withType: (type) ->
    @filter (record) -> record.constructor == type

  prepareForReplace: (idx, amt, objects) ->
    objects = Ember.A(objects).map (o) ->
      if Ember.isArray(o)
        o
      else
        type = o.constructor
        clientId = o.get('clientId')
        [type, clientId]

    [idx, amt, objects]

# Allow to create attributes for extended record array,
# usage is similar to attrs from data store:
#
# items: Radium.ExtendedRecordArray.attr(key: 'item_ids')
#
# You need to pass key, it does not compute any default.
Radium.ExtendedRecordArray.reopenClass
  attr: (name, options) ->
    self = this
    options ?= {}
    mixins = options.mixins

    ( ->
      store = @get('store')

      if ids = @get("data.attributes.#{name}")
        ids = ids.map (element) ->
          [type, id] = element
          record = store.find(type, id)
          [type, record.get('clientId')]

      args = mixins || []
      args.pushObject
        store: @get('store')
        content: Ember.A(ids)

      self.create.apply(self, args)
      # using attribute in meta() ensures that this data will be available
      # in data.attributes.
      # TODO: check what happens when using isAssociation, maybe it will be better
      # to actually treat it like that
    ).property('data').meta(isAttribute: true, type: 'array')


# I suck at naming, if you have better idea, please rename (the
# same thing applies to ExtendedRecordArray)
Radium.ClusteredExtendedArray = Radium.ExtendedRecordArray.extend()
