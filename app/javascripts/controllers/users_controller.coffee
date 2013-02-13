Radium.UserItemController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  meIfCurrent: (->
    content = @get 'content'

    if content is @get('currentUser')
      'Me'
    else
      content.get 'name'
  ).property('name', 'currentUser')

Radium.UsersController = Ember.ArrayController.extend
  itemController: 'userItem'
