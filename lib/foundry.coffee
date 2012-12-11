types = "Boolean Number String Function Array Date RegExp Object".split(" ")
TYPE_MAP = []

for type in types
  TYPE_MAP[ "[object " + type + "]" ] = type.toLowerCase()

class Foundry
  constructor: ->
    @definitions = {}
    @traits = {}

  sequence: (callback) ->
    counter = 0
    callback ?= (i) -> "#{i}"

    -> callback(++counter)

  trait: (name, attributes) ->
    @traits[name] = attributes

  typeOf: (item) ->
    if item == null or item == undefined
      String(item) 
    else
      TYPE_MAP[Object::toString.call(item)] || 'object'

  define: (klass, options, attributes) ->
    if @definitions.hasOwnProperty klass
      throw new Error("there is an existing factory definition for #{klass}")

    if arguments.length == 2
      attributes = options
      options = {}
    else if arguments.length == 3
      options ||= {}
    else if arguments.length == 1
      options = {}
      attributes = {}

    attributes ||= {}
    attributes.id ||= @sequence()

    parent = options.from

    if parent and @definitions.hasOwnProperty(parent)
      attributes = $.extend {}, @definitions[parent], attributes
    else if parent and !@definitions.hasOwnProperty(parent)
      throw new Error("Undefined factory: #{parent}")

    options.traits ||= []
    options.traits = [options.traits] if typeof(options.traits) == 'string'

    for trait in options.traits
      unless @traits.hasOwnProperty trait
        throw new Error("there is no trait definition for #{trait}")
      attributes = $.extend true, {}, @traits[trait], attributes

    @definitions[klass] = attributes

  build: (klass, attributes = {}) ->
    unless @definitions.hasOwnProperty klass
      throw new Error("there is no factory definition for #{klass}")

    definition = @definitions[klass]
    instance = $.extend true, {}, definition, attributes

    @_evaluateFunctions instance


  _evaluateFunctions: (record) ->
    for k, v of record
      switch @typeOf v
        when 'function'
          result = record[k]()
          delete record[k]
          record[k] = result
        when 'object'
          record[k] = @_evaluateFunctions v
        else
          record

    record


  create: (klass, attributes = {}) ->
    throw new Error("Cannot create without an adapter!") unless @adapter

    object = @build klass, attributes
    @adapter.save klass, object

  tearDown: ->
    for k, v of @definitions
      delete @definitions[k]
    for k, v of @traits
      delete @traits[k]

class NullAdapter
  save: (klass, record) ->
    record

class EmberDataAdapter
  constructor: (@store, @map) ->

  modelForType: (type) ->
    if lookupResult = Ember.get(Ember.lookup, type)
      lookupResult
    else if @map and @map.get type
      @map.get type
    else
      throw new Error("Cannot find an Ember Data model for #{type}")

  # Process the hash and recurse on associations.
  # This will transform hasMany keys from objects to an array of FKS
  # This will transform belongsTo keys from objects to a FK
  # Parent is the record from previous call
  loadRecord: (model, record, parent, parentAssociation) ->
    associations = Ember.get(model, 'associationsByName')

    # Leaf node in tree, time to load data into
    # the store
    if associations.keys.isEmpty()
      model.FIXTURES ||= []
      model.FIXTURES.push record
      @store.load model, record
    else
      associations.forEach (name, association) =>
        kind = association.kind
        type = association.type

        throw new Error("Cannot find a type for: #{model}.#{name}!") unless type

        associatedObject = record[name]

        switch kind
          when "belongsTo"
            parentKey = "#{name}_id"
            if associatedObject
              record[parentKey] = associatedObject.id
              @loadRecord type, associatedObject, record, name
            else if parent && Ember.typeOf(parent[parentAssociation]) == "array" && parent[parentAssociation].indexOf(record.id) >= 0
              record[parentKey] = parent.id
            else if parent && parent[parentAssociation] == record.id
              record[parentKey] = parent.id
          when "hasMany"
            if associatedObject
              associatedObjects = Ember.A(associatedObject)
              ids = associatedObject.map (o) -> o.id
              record[name] = ids

              associatedObjects.forEach (childRecord) =>
                @loadRecord type, childRecord, record, name
            else if parent && parent[parentAssociation] = record.id
              record[name] ||= []
              record[name].push parent.id

      Ember.get(model, 'polymorphicAttributes').forEach (name, associations) =>
        return unless  record[name]

        associatedObject = record[name]
        type = @modelForType(associatedObject.type)
        #HACK: Until I get this working object is in the id
        #e.g. id: -> Factory.build 'user'
        @loadRecord type, associatedObject.id
        id = associatedObject.id.id
        delete associatedObject.id
        associatedObject.id = id

      # Now all the associations in this node have been processed
      # it's safe to add the leaf node
      model.FIXTURES ||= []
      model.FIXTURES.push record
      @store.load model, record

  save: (type, record) ->
    throw new Error("Cannot save without a store!") unless @store

    model = @modelForType type
    @loadRecord model, record
    @store.find model, record.id

Foundry.NullAdapter = NullAdapter
Foundry.EmberDataAdapter = EmberDataAdapter

window.Foundry = Foundry
