require "mixins/lists_persistence_mixin"

Radium.VariadicRowComponent = Ember.Component.extend Radium.ListsPersistenceMixin,
  Radium.ComponentContextHackMixin,
  actions:
    addList: (list) ->
      @_super @get('model'), list

      false

    removeList: (list) ->
      @_super @get('model'), list

      false

  tagName: "tr"

  classNameBindings: ['item.isChecked:is-checked', 'item.read:read:unread']
  attributeBindings: ['dataModel:data-model']

  dataModel: Ember.computed.oneWay 'item.id'

  model: Ember.computed.oneWay 'item'

  # UPGRADE: replace with inject
  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')

  users: Ember.computed ->
    @container.lookup('controller:users')

  leadSources: Ember.computed ->
    @container.lookup('controller:accountSettings').get('leadSources')

  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')

  tags: Ember.computed ->
    @container.lookup('controller:tags')

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    return unless contactStatuses = @get('contactStatuses')

    contactStatuses.reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'item.user', ->
    @get('users').reject (user) =>
      user == @get('user')
