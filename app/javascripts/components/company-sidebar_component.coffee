require "mixins/persist_tags_mixin"

Radium.CompanySidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.PersistTagsMixin,
  actions:
    addTag: (tag) ->
      @_super @get('company'), tag

      false

    removeTag: (tag) ->
      @_super @get('company'), tag

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
  tags: Ember.computed ->
    @container.lookup('controller:tags')

  users: Ember.computed ->
    @container.lookup('controller:users')
