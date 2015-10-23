require "mixins/lists_persistence_mixin"
require "mixins/common_drawer_actions"
require "mixins/save_contact_actions"

Radium.ContactSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.ListsPersistenceMixin,
  Radium.CommonDrawerActions,
  Radium.SaveContactActions,

  actions:
    createList: (list) ->
      @sendAction "createList", list, @get('contact')

      false

    addList: (list) ->
      @_super @get('contact'), list

      false

    removeList: (list) ->
      @_super @get('contact'), list

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
      @set "showDeleteConfirmation", true

      false

    showCompany: (contact) ->
      company = contact.get('company')

      @send "showCompanyDrawer", company

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

  peopleController: Ember.computed ->
    @container.lookup('controller:peopleIndex')

  shared: false
  isSaving: false
  condense: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')

  lists: Ember.computed.oneWay 'listsService.sortedLists'
