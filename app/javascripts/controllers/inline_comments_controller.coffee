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

      if @get('feedItem.type')
        plural = Radium.store.adapter.pluralize(type)
        url = '%@/%@/comments'.fmt(plural, id)
      else
        url = 'activities/%@/comments'.fmt(id)

      Radium.Comment.reopenClass
        url: url
        root: 'comment'

      comment = Radium.store.createRecord Radium.Comment,
        text: commentText
        createdAt: Ember.DateTime.create()
        user: Radium.router.get('meController.user')

      @set('isError', false)
      @set('newComment', '')
      @get('comments').pushObject(comment)

      Radium.store.commit()

      comment.addObserver 'isValid', ->
        if @get('isValid')
          Radium.Comment.reopenClass
            url: null
            root: null
        else
          self.set('isError', true)
          self.set('newComment', commentText)
    else
      self.set('isError', true)
