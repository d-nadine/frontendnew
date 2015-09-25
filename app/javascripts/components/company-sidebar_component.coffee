require "mixins/lists_persistence_mixin"
require "mixins/common_drawer_actions"

Radium.CompanySidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.ListsPersistenceMixin,
  Radium.CommonDrawerActions,
  actions:
    addList: (list) ->
      @_super @get('company'), list

      false

    removeList: (list) ->
      @_super @get('company'), list

      false

    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

  model: Ember.computed.oneWay 'company'

  membersText: Ember.computed 'company.contacts.[]', ->
    return unless contacts = @get('company.contacts')

    "View all #{contacts.get('length')} contacts."

  truncatedContacts: Ember.computed 'company.contacts.[]', 'model', ->
    return unless contacts = @get('company.contacts')

    contacts.toArray().sort((left, right) ->
      Ember.compare(left.get('name'), right.get('name'))).slice(0, 3)

  hasMoreContacts: Ember.computed 'company.contacts.[]', 'truncatedContacts', ->
    count = @get('company.contacts.length')

    return unless count

    count > @get('truncatedContacts.length')

  # UPGRADE: replace with inject
  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')

  users: Ember.computed ->
    @container.lookup('controller:users')
