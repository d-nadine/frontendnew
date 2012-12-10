class Factory
  constructor: ->
    @definitions = {}
    @traits = {}

  sequence: (callback) ->
    counter = 0
    callback ?= (i) -> "#{i}"

    -> callback(++counter)

  trait: (name, attributes) ->
    @traits[name] = attributes

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
      attributes = $.extend {}, @traits[trait], attributes

    @definitions[klass] = attributes

  build: (klass, attributes = {}) ->
    unless @definitions.hasOwnProperty klass
      throw new Error("there is no factory definition for #{klass}")

    definition = @definitions[klass]
    instance = $.extend {}, definition, attributes

    for k, v of instance when typeof v is 'function'
      result = instance[k]()
      delete instance[k]
      instance[k] = result

    instance

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
  constructor: (@store) ->

  modelForType: (type) ->
    if typeof type == 'string'
      Ember.get Ember.lookup, type
    else
      type

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
            if associatedObject
              record[name] = associatedObject.id
              @loadRecord type, associatedObject, record, name
            else if Ember.typeOf(parent[parentAssociation]) == "array" && parent[parentAssociation].indexOf(record.id) >= 0
              record[name] = parent.id
            else if parent[parentAssociation] == record.id
              record[name] = parent.id
          when "hasMany"
            if associatedObject
              associatedObjects = Ember.A(associatedObject)
              ids = associatedObject.map (o) -> o.id
              record[name] = ids

              associatedObjects.forEach (childRecord) =>
                @loadRecord type, childRecord, record, name

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

runningFactory = new Factory()
runningFactory.adapter = new NullAdapter()

runningFactory.NullAdapter = NullAdapter
runningFactory.EmberDataAdapter = EmberDataAdapter

window.Factory = runningFactory
