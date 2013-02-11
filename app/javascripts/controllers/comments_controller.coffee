Radium.CommentsController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  contentDidChange: (->
    @reset()
  ).observes('content')

  reset: ->
    comment = Radium.Comment.createRecord commentable: @get('model'), user: @get('currentUser')
    @set 'comment', comment

  submit: ->
    comment = @get 'comment'

    @get('comments').pushObject comment
    @reset()
