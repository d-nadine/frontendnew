require "mixins/lists_persistence_mixin"

Radium.ContactSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.ListsPersistenceMixin,
  actions:
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
      @closeCompanyDrawer()

      @set "companyModel", contact.get('company')

      config = {
        bindings: [{
          name: "company",
          value: "companyModel"
        },
        {
          name: "closeDrawer",
          value: "closeDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "hideDeals",
          value: true,
          static: true
        },
        {
          name: "deleteCompany",
          value: "deleteCompany",
          static: true
        },
        {
          name: "hideMain",
          value: true,
          static: true
        }
        ],
        component: 'x-company'
      }

      Ember.run.next =>
        @set 'companyParams', config

        @set 'showCompanyDrawer', true

      false


    closeCompanyDrawer: ->
      @closeCompanyDrawer()

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

  showCompanyDrawer: false
  companyModel: null
  companyParams: null

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')

  closeCompanyDrawer: ->
    @set 'showCompanyDrawer', false
    @set 'companyModel', null
    @set 'companyParams', null
