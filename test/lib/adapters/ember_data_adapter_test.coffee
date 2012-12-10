TestTodo = DS.Model.extend
  primaryKey: 'id'
  task: DS.attr('string')

TestProfile = DS.Model.extend
  primaryKey: 'id'
  text: DS.attr('string')

TestAuthor = DS.Model.extend
  primaryKey: 'id'
  name: DS.attr('string')

TestPost = DS.Model.extend
  primaryKey: 'id'
  title: DS.attr('string')

TestComment = DS.Model.extend
  primaryKey: 'id'
  text: DS.attr('string')

# Reopen the classes and delcare the associations
TestProfile.reopen
  author: DS.belongsTo(TestAuthor)

TestAuthor.reopen
  profile: DS.belongsTo(TestProfile)

TestPost.reopen
  comments: DS.hasMany(TestComment)

TestComment.reopen
  post: DS.belongsTo(TestPost)

TestAuthor.FIXTURES = []
TestProfile.FIXTURES = []
TestTodo.FIXTURES = []
TestPost.FIXTURES = []
TestComment.FIXTURES = []

TestStore = DS.Store.extend
  revision: 9
  adapter: DS.FixtureAdapter.create
    simulateRemoteResponse: false

store = null

typeMap = Ember.Map.create()
typeMap.set 'TestPost', TestPost
typeMap.set 'TestComment', TestComment
typeMap.set 'TestAuthor', TestAuthor
typeMap.set 'TestProfile', TestProfile,
typeMap.set 'TestTodo', TestTodo

module 'Ember-Data factory adapter',
  setup: ->
    store = TestStore.create()

    Factory.adapter = new Factory.EmberDataAdapter(store, typeMap)

    Factory.define 'TestTodo'
      task: Factory.sequence (i) -> "Todo #{i}"

    Factory.define 'TestProfile'
      text: Factory.sequence (i) -> "Profile #{i}"

    Factory.define 'TestAuthor'
      name: Factory.sequence (i) -> "Author #{i}"
      profile: Factory.build 'TestProfile'

    Factory.define 'TestComment'
      text: Factory.sequence (i) -> "Comment #{i}"

    Factory.define 'TestPost'
      title: Factory.sequence (i) -> "Post #{i}"
      comments: [Factory.build('TestComment')]

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
  equal TestTodo.FIXTURES.length, 1, "FIXTURES array not updated"

  # TODO: How to get the attribute has to compare?
  inMemoryRecord = TestTodo.FIXTURES[0]
  equal todo.get('task'), inMemoryRecord.task

test 'creating an object persists a belongsTo relationship', ->
  equal TestAuthor.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestProfile.FIXTURES.length, 0, "Child FIXTURES empty"

  Factory.create 'TestAuthor'

  author = store.find TestAuthor, 1

  equal author.get('profile.text'), 'Profile 1', 'belongsTo relationship materialized on the parent'
  equal TestAuthor.FIXTURES.length, 1, 'Parent FIXTURES array updated'
  inMemoryRecord = TestAuthor.FIXTURES[0]
  strictEqual inMemoryRecord.profile, '1', 'Parent belongsTo transformed into FK'

  profile = store.find TestProfile, 1
  equal profile.get('text'), 'Profile 1', 'child record materialized correctly'
  equal TestProfile.FIXTURES.length, 1, 'child FIXTURES array updated'
  inMemoryRecord = TestProfile.FIXTURES[0]
  strictEqual inMemoryRecord.author, '1', 'Child belongsTo transformed into FK'
  equal profile.get('author.name'), 'Author 1', 'belongsTo relationship materialized on the child'

test 'creating an object persists a hasMany relationship', ->
  equal TestPost.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestComment.FIXTURES.length, 0, "Child FIXTURES empty"

  Factory.create 'TestPost'

  post = store.find TestPost, 1

  equal post.get('comments.length'), 1, 'Parent hasMany has correct # of children'
  comment = post.get('comments.firstObject')

  equal comment.get('text'), 'Comment 1', 'hasMany relationship materialized on the parent'
  equal TestPost.FIXTURES.length, 1, 'Parent FIXTURES array updated'
  inMemoryRecord = TestPost.FIXTURES[0]
  equal Ember.typeOf(inMemoryRecord.comments), "array", "Fixture record hasMany stored as an array"
  equal inMemoryRecord.comments[0], "1", 'Parent hasMany transformed into FK'

  comment = store.find TestComment, 1
  equal comment.get('text'), 'Comment 1', 'child record materialized correctly'
  equal TestComment.FIXTURES.length, 1, 'child FIXTURES array updated'
  inMemoryRecord = TestComment.FIXTURES[0]
  strictEqual inMemoryRecord.post, '1', 'Child belongsTo transformed into FK'
  equal comment.get('post.title'), 'Post 1', 'belongsTo relationship materialized on the child'

