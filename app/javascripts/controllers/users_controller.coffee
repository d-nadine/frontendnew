Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  meIfCurrent: (->
    content = @get 'content'

    if content is @get('currentUser')
      'Me'
    else
      content.get 'name'
  ).property('name', 'currentUser')

  isAdmin: ( ->
    if arguments.length == 2
      @set('model.isAdmin', true)
      @get('store').commit() 
    else
      @get('model.isAdmin')
  ).property('model.isAdmin')

  toggleIsAdmin: ->
    return if @get('isSaving')
    @toggleProperty('isAdmin')

  removeAsAdmin: ->
    @set('isAdmin', false)

Radium.UsersController = Radium.ArrayController.extend
  itemController: 'userItem'
  sortProperties: ['lastName']
