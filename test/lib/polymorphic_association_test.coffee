# store = null
# Comment = null
# Post = null
# Article = null

# module 'Polymorphic rel',
#   setup: ->
#     store = Radium.Store.create()
#     store.get('_adapter').set('simulateRemoteResponse', false)
#     store.get('_adapter').set 'serializer', Radium.Serializer.create(
#       typeFromString: (type) ->
#         if type == 'comment'
#           Comment
#         else if type == 'post'
#           Post
#         else if type == 'article'
#           Article
#     )

#     Post    = Radium.Core.extend(toString: 'Post')
#     Article = Radium.Core.extend(toString: 'Article')
#     Comment = Radium.Core.extend
#       toString: 'Comment'
#       commentable: Radium.polymorphicAttribute()
#       # need to specify all possible associations for commentable
#       post: DS.belongsTo(Post, polymorphicFor: 'commentable')
#       article: DS.belongsTo(Article, polymorphicFor: 'commentable')

#     Post.reopen
#       comments: DS.hasMany(Comment)
#     Article.reopen
#       comments: DS.hasMany(Comment)

#   teardown: ->
#     store.destroy()

# test 'when loading record from JSON, it properly populates relationship', ->
#   store.load Post, { id: 1 }
#   store.load Comment,
#     id: 1
#     commentable: {
#       id: 1,
#       type: 'post'
#     }

#   comment = store.find Comment, 1
#   post    = store.find Post, 1

#   equal comment.get('commentable'), post, ''
#   equal comment.get('post'), post, ''

# test 'when setting polymorphic association, it sets proper "real" association', ->
#   store.load Post, { id: 1 }
#   store.load Article, { id: 1 }
#   store.load Comment,
#     id: 1
#     commentable: {
#       id: 1,
#       type: 'post'
#     }

#   comment = store.find Comment, 1
#   post    = store.find Post, 1
#   article = store.find Article, 1


#   equal comment.get('commentable'), post, ''

#   comment.set 'commentable', article

#   equal comment.get('commentable'), article, ''
#   equal comment.get('article'), article, ''
#   equal comment.get('post'), null, ''
