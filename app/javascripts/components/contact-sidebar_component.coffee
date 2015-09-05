require "mixins/persist_tags_mixin"

Radium.ContactSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.PersistTagsMixin,
  actions:
    addTag: (tag) ->
      @_super @get('contact'), tag

      false

    removeTag: (tag) ->
      @_super @get('contact'), tag

      false

    switchShared: ->
      Ember.run.next =>
        contact = @get('contact')
        contact.toggleProperty('isPublic')

        unless contact.get('isPublic')
          contact.set "potentialShare", true

        contact.save().then =>
          @get('peopleController')?.send 'updateTotals'

          @sendAction("startPolling") if contact.get('isUpdating')

      false

    confirmDeletion: ->
      @sendAction "confirmDeletion"

      false

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')

  companies: Ember.computed ->
    @container.lookup('controller:companies')

  users: Ember.computed ->
    @container.lookup('controller:users')

  leadSources: Ember.computed ->
    @container.lookup('controller:accountSettings').get('leadSources')

  tags: Ember.computed ->
    @container.lookup('controller:tags')

  peopleController: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  shared: false
  isSaving: false
  condense: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')
