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

      comment = @get('comments').createRecord
        text: commentText
        createdAt: Ember.DateTime.create()
        user: Radium.get('router').user
        commentableType: type
        commentableId: id
        todo: @get('feedItem')

      @set('isError', false)
      @set('newComment', '')

      comment.commit()

      comment.addObserver 'isValid', ->
        unless @get('isValid')
          self.set('isError', true)
          self.set('newComment', commentText)
    else
      self.set('isError', true)
