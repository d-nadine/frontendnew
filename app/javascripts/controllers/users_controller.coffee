Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  meIfCurrent: (->
    content = @get 'content'

    if content is @get('currentUser')
      'Me'
    else
      content.get 'name'
  ).property('name', 'currentUser')

Radium.UsersController = Radium.ArrayController.extend
  itemController: 'userItem'
