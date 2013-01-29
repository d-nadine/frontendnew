Radium.CommentsController = Ember.ObjectController.extend
  contentDidChange: (->
    @reset()
  ).observes('content')

  reset: ->
    comment = Radium.Comment.createRecord commentable: @get('model')
    @set 'comment', comment

  submit: ->
    console.log @get('content.constructor')

    comment = @get 'comment'

    @get('comments').pushObject comment
    @reset()
