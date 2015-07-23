require "mixins/persist_tags_mixin"

Radium.VariadicRowComponent = Ember.Component.extend Radium.PersistTagsMixin,
  Radium.ComponentContextHackMixin,
  actions:
    addTag: (tag) ->
      @_super @get('model'), tag

      false

    removeTag: (tag) ->
      @_super @get('model'), tag

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

  tags: Ember.computed ->
    @container.lookup('controller:tags')

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    return unless contactStatuses = @get('contactStatuses')

    contactStatuses.reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'item.user', ->
    @get('users').reject (user) =>
      user == @get('user')
