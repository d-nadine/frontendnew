Radium.CommentsController = Radium.ObjectController.extend
  text: null

  submit: ->
    comment = @get('comments').createRecord
      user: @get('currentUser')
      text: @get('text')

    @get('store').commit()

    @set 'text', null
