TestTodo = DS.Model.extend
  primaryKey: 'id'
  task: DS.attr('string')

TestAuthor = DS.Model.extend
  primaryKey: 'id'
  name: DS.attr('string')

TestProfile = DS.Model.extend
  primaryKey: 'id'
  text: DS.attr('string')

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
typeMap.set 'TestCommentWithPost', TestComment

foundry = null

module 'Ember-Data foundry adapter',
  setup: ->
    store = TestStore.create()

    foundry = new Foundry()
    foundry.adapter = new Foundry.EmberDataAdapter(store, typeMap)

    foundry.define 'TestTodo'
      task: foundry.sequence (i) -> "Todo #{i}"

    foundry.define 'TestProfile'
      text: foundry.sequence (i) -> "Profile #{i}"

    foundry.define 'TestAuthor'
      name: foundry.sequence (i) -> "Author #{i}"
      profile: foundry.build 'TestProfile'

    foundry.define 'TestComment'
      text: foundry.sequence (i) -> "Comment #{i}"

    foundry.define 'TestPost'
      title: foundry.sequence (i) -> "Post #{i}"
      comments: [foundry.build('TestComment')]

    foundry.define 'TestCommentWithPost'
      text: foundry.sequence (i) -> "Comment #{i}"
      post:
        id: 1
        title: "Post 1"

    TestTodo.FIXTURES.splice 0, TestTodo.FIXTURES.length
    TestAuthor.FIXTURES.splice 0, TestAuthor.FIXTURES.length
    TestProfile.FIXTURES.splice 0, TestProfile.FIXTURES.length
    TestComment.FIXTURES.splice 0, TestComment.FIXTURES.length
    TestPost.FIXTURES.splice 0, TestPost.FIXTURES.length

  teardown: ->
    foundry.tearDown()
    TestTodo.FIXTURES.splice 0, TestTodo.FIXTURES.length
    TestAuthor.FIXTURES.splice 0, TestAuthor.FIXTURES.length
    TestProfile.FIXTURES.splice 0, TestProfile.FIXTURES.length
    TestPost.FIXTURES.splice 0, TestPost.FIXTURES.length
    store.destroy()

test 'creating an object persists it in ember-data', ->
  equal TestTodo.FIXTURES.length, 0

  foundry.create 'TestTodo'

  todo = store.find TestTodo, 1

  equal todo.get('task'), 'Todo 1'
  equal TestTodo.FIXTURES.length, 1, "FIXTURES array not updated"

  # TODO: How to get the attribute has to compare?
  inMemoryRecord = TestTodo.FIXTURES[0]
  equal todo.get('task'), inMemoryRecord.task

test 'creating an object persists a belongsTo relationship', ->
  equal TestAuthor.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestProfile.FIXTURES.length, 0, "Child FIXTURES empty"

  foundry.create 'TestAuthor'

  author = store.find TestAuthor, 1

  equal author.get('profile.text'), 'Profile 1', 'belongsTo relationship materialized on the parent'
  equal TestAuthor.FIXTURES.length, 1, 'Parent FIXTURES array updated'
  inMemoryRecord = TestAuthor.FIXTURES[0]
  strictEqual inMemoryRecord.profile, '1', 'Parent belongsTo transformed into FK'

  profile = store.find TestProfile, 1
  equal profile.get('text'), 'Profile 1', 'child record materialized correctly'
  equal TestProfile.FIXTURES.length, 1, 'child FIXTURES array updated'
  inMemoryRecord = TestProfile.FIXTURES[0]
  strictEqual inMemoryRecord.author.id, '1', 'Child belongsTo transformed into FK'
  equal profile.get('author.name'), 'Author 1', 'belongsTo relationship materialized on the child'

test 'creating an object persists a hasMany relationship', ->
  equal TestPost.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestComment.FIXTURES.length, 0, "Child FIXTURES empty"

  foundry.create 'TestPost'

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

test 'creating an object from the belongsTo side persists a hasMany relationship', ->
  equal TestPost.FIXTURES.length, 0, "Parent FIXTURES empty"
  equal TestComment.FIXTURES.length, 0, "Child FIXTURES empty"

  foundry.create 'TestCommentWithPost'

  comment = store.find TestComment, 1

  equal comment.get('text'), 'Comment 1', 'hasMany relationship materialized on the parent'
  equal TestComment.FIXTURES.length, 1, 'Child FIXTURES array updated'
  inMemoryRecord = TestComment.FIXTURES[0]
  equal inMemoryRecord.post, '1', 'child belongsTo transformed into FK'
  ok comment.get('post'), "child belongsTo association loaded"

  post = store.find TestPost, 1
  equal post.get('title'), 'Post 1', 'parent record materialized correctly'
  equal TestPost.FIXTURES.length, 1, 'Parent FIXTURES array updated'
  inMemoryRecord = TestPost.FIXTURES[0]
  equal inMemoryRecord.comments[0], '1', "Parent to child FK correct"
  ok post.get('comments'), "hasMany association loaded correctly on the parent"

