require "mixins/persist_tags_mixin"

Radium.VariadicItemController = Radium.ObjectController.extend Radium.PersistTagsMixin,
  actions:
    addTag: (tag) ->
      @_super @get('model'), tag

      false

    removeTag: (tag) ->
      @_super @get('model'), tag

      false

  needs: ['users']
  users: Ember.computed.oneWay 'controllers.users'
  contactStatuses: Ember.computed.oneWay 'parentController.targetObject.contactStatuses'

  assignedTo: Ember.computed.alias 'user'
  contact: Ember.computed.alias 'model'

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    return unless contactStatuses = @get('contactStatuses')

    contactStatuses.reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'user', ->
    @get('users').reject (user) =>
      user == @get('user')

  isSaving: false
