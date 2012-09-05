Radium.reopen
  # Create polymorphic property for given key.
  # It's really dead simple implementation which will not
  # behave as real association.
  #
  # TODO: add polymorphic keys support to ember-data
  polymorphic: (key) ->
    idKey   = "data.#{key}.id"
    typeKey = "data.#{key}.type"
    ( (key, value) ->
      if value
        type = value.get 'type'
        id   = value.get 'id'

        @set "data.#{key}", { id: id, type: type }

      if type = @get(typeKey)
        type = Radium.Core.typeFromString(type)
        Radium.store.find type, @get(idKey)
    ).property(idKey, typeKey)
