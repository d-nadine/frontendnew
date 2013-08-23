Radium.CommentsController = Radium.ObjectController.extend
  text: null

  submit: ->
    comment = @get('comments').createRecord
      user: @get('currentUser.model')
      text: @get('text')
      commentable: @get('model')

    @get('store').commit()

    @set 'text', null
