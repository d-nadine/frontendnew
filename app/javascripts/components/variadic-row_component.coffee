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

    createList: (list) ->
      @sendAction "createList", list, @get('model')

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

  lists: Ember.computed.oneWay 'listsService.sortedLists'

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    return unless contactStatuses = @get('contactStatuses')

    contactStatuses.reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'item.user', ->
    @get('users').reject (user) =>
      user == @get('user')

  modelUpdated: (model) ->
    return if @isDestroyed || @isDestroying
    Ember.run.scheduleOnce('render', this, 'rerender')

  modelIdentifier: null

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments
    return unless @get('model.id')

    model = @get('model')

    return unless model.updatedEventKey

    @modelIdentifier = model.updatedEventKey()

    @EventBus.subscribe @modelIdentifier, this, "modelUpdated"

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    return unless modelIdentifier = @modelIdentifier

    @EventBus.unsubscribe modelIdentifier
