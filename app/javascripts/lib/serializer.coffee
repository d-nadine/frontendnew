Radium.Serializer = DS.RESTSerializer.extend
  init: ->
    @_super.apply(this, arguments)
    for name, transform of Radium.transforms
      @registerTransform name, transform

  materializeFromData: (record, hash) ->
    eachPolymorphicAttribute = (name, attribute) ->
      polymorphicData = @extractAttribute(record.constructor, hash, name)
      if polymorphicData
        @materializePolymorphicAssociation(record, hash, name, polymorphicData)

    if record.eachPolymorphicAttribute
      record.eachPolymorphicAttribute eachPolymorphicAttribute, this

    @_super record, hash

  typeFromString: (type) ->
    Radium.Core.typeFromString(type)

  materializePolymorphicAssociation: (record, hash, name, polymorphicData) ->
    type = record.constructor

    associationType = @typeFromString(polymorphicData.type)
    associations = Ember.get(type, 'associations').get(associationType).map (association) ->
      Ember.get(type, 'associationsByName').get(association.name)

    polymorphic = associations.find (association) -> association.options?.polymorphicFor == name

    Ember.assert("Could not find association with type #{@typeFromString(polymorphicData.type)} for #{name} polymorphic association in #{record.constructor}", polymorphic)
    hash["#{polymorphic.key}_id"] = polymorphicData.id
