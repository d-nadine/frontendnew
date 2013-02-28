Radium.CommentsController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  text: null

  submit: ->
    comment = @get('comments').createRecord
      user: @get('currentUser')
      text: @get('text')

    @get('store').commit()

    @set 'text', null
