Radium.CommentsController = Radium.ObjectController.extend
  actions:
    submit: ->
      comment = @get('comments').createRecord
        user: @get('currentUser')
        text: @get('text')
        commentable: @get('model')

      @get('store').commit()

      @set 'text', null

  text: null
