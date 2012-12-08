TestAuthor = null
TestProfile = null
TestTodo = null

TestTodo = DS.Model.extend
  primaryKey: 'id'
  task: DS.attr('string')

TestProfile = DS.Model.extend
  primaryKey: 'id'
  text: DS.attr('string')

TestAuthor = DS.Model.extend
  primaryKey: 'id'
  name: DS.attr('string')

# Reopen the classes and delcare the associations
TestProfile.reopen
  author: DS.belongsTo(TestAuthor)

TestAuthor.reopen
  profile: DS.belongsTo(TestProfile)

window.TestAuthor = TestAuthor

TestAuthor.FIXTURES = []
TestProfile.FIXTURES = []
TestTodo.FIXTURES = []

TestStore = DS.Store.extend
  revision: 9
  adapter: DS.FixtureAdapter.create
    simulateRemoteResponse: false

store = null

class EmberDataAdapter
  constructor: (@store) ->

  modelForType: (type) ->
    switch type
      when "TestPost" then TestPost
      when "TestComment" then TestComment
      when "TestAuthor" then TestAuthor
      when "TestProfile" then TestProfile
      else
        throw new Error("Cannot locate an ember data model for: #{type}")

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
            else if parent[parentAssociation] == record.id
              record[name] = parent.id

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

# start hacking on an adapter that can be refactored later
Factory.create = (klass, attributes = {}) ->
  object = @build klass, attributes
  @adapter.save klass, object

module 'Ember-Data factory adapter',
  setup: ->
    store = TestStore.create()

    Factory.adapter = new EmberDataAdapter(store)

    Factory.define 'TestTodo'
      task: Factory.sequence (i) -> "Todo #{i}"

    Factory.define 'TestProfile'
      text: Factory.sequence (i) -> "Profile #{i}"

    Factory.define 'TestAuthor'
      name: Factory.sequence (i) -> "Author #{i}"
      profile: Factory.build 'TestProfile'

  teardown: ->
    Factory.tearDown()
    TestTodo.FIXTURES.splice 0, TestTodo.FIXTURES.length
    TestAuthor.FIXTURES.splice 0, TestAuthor.FIXTURES.length
    TestProfile.FIXTURES.splice 0, TestProfile.FIXTURES.length
    store.destroy()

test 'creating an object persists it in ember-data', ->
  equal TestTodo.FIXTURES.length, 0

  Factory.create 'TestTodo'

  todo = store.find TestTodo, 1

  equal todo.get('task'), 'Todo 1'
  equal Todo.FIXTURES.length, 1, "FIXTURES array not updated"

  # TODO: How to get the attribute has to compare?
  inMemoryRecord = Todo.FIXTURES[0]
  equal todo.get('task'), inMemoryRecord.task

test 'creating an object persists a belongsTo relationship', ->
  equal TestAuthor.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestProfile.FIXTURES.length, 0, "Child FIXTURES empty"

  Factory.create 'TestAuthor'

  author = store.find TestAuthor, 1

  equal author.get('profile.text'), 'Profile 1', 'belongsTo relationship materialized on the parent'
  equal TestAuthor.FIXTURES.length, 1, 'Parent FIXTURES array updated'
  inMemoryRecord = TestAuthor.FIXTURES[0]
  equal inMemoryRecord.profile, ['1'], 'Parent belongsTo transformed into FK'

  profile = store.find TestProfile, 1
  equal profile.get('text'), 'Profile 1', 'child record materialized correctly'
  equal TestProfile.FIXTURES.length, 1, 'child FIXTURES array updated'
  inMemoryRecord = TestProfile.FIXTURES[0]
  equal inMemoryRecord.author, ['1'], 'Child belongsTo transformed into FK'
  equal profile.get('author.name'), 'Author 1', 'belongsTo relationship materialized on the child'
