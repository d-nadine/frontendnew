Radium.InlineCommentsController = Ember.ArrayController.extend
  commentsBinding: 'feedItem.comments'
  targetBinding: 'Ember.router'

  newComment: ""
  isError: false
  isSubmitting: false
  addComment: ->
    self = this
    if (commentText = @get('newComment')) != ''
      id = @get('feedItem.id')
      type = @get('feedItem.type') || @get('feedItem.kind')

      comment = Radium.store.createRecord Radium.Comment,
        text: commentText
        createdAt: Ember.DateTime.create()
        user: Radium.router.get('meController.user')
        commentableType: type
        commentableId: id

      @set('isError', false)
      @set('newComment', '')
      @get('comments').pushObject(comment)

      Radium.store.commit()

      comment.addObserver 'isValid', ->
        unless @get('isValid')
          self.set('isError', true)
          self.set('newComment', commentText)
    else
      self.set('isError', true)
