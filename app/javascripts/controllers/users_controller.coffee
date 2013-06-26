Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  meIfCurrent: (->
    content = @get 'content'

    if content is @get('currentUser')
      'Me'
    else
      content.get 'name'
  ).property('name', 'currentUser')

  makeAdmin: ->
    @set('isAdmin', true)

  removeAsAdmin: ->
    @set('isAdmin', false)

Radium.UsersController = Radium.ArrayController.extend
  itemController: 'userItem'
