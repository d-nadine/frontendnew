Radium.InlineCommentsController = Ember.ArrayController.extend
  commentsBinding: 'commentParent.comments'
  targetBinding: 'Ember.router'

  newComment: ""
  isError: false
  isSubmitting: false
  addComment: ->
    self = this
    if (commentText = @get('newComment')) != ''
      id = @get('commentParent.id')
      type = @get('commentParent.type') || @get('commentParent.kind')

      comment = @get('comments').createRecord
        text: commentText
        createdAt: Ember.DateTime.create()
        user: Radium.get('router').user
        commentableType: type
        commentableId: id
        todo: @get('commentParent')

      @set('isError', false)
      @set('newComment', '')

      comment.commit()

      comment.addObserver 'isValid', ->
        unless @get('isValid')
          self.set('isError', true)
          self.set('newComment', commentText)
    else
      self.set('isError', true)
