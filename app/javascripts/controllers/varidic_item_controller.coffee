Radium.VaridicItemController = Ember.ObjectController.extend
  needs: ['users']
  users: Ember.computed.oneWay 'controllers.users'

  assignedTo: Ember.computed.alias 'user'
  contact: Ember.computed.alias 'model'

  assignees: Ember.computed 'users.[]', 'user', ->
    @get('users').reject (user) =>
      user == @get('user')