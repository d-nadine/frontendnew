require 'components/deal_columns_config'
require "mixins/table_column_selections"

Radium.XListComponent = Ember.Component.extend Radium.DealColumnsConfig,
  Radium.TableColumnSelectionsMixin,
  actions:
    loadMoreDeals: ->
      deals = @get('deals')

      observer = ->
        return if deals.get('isLoading')
        deals.removeObserver 'isLoading', observer
        deals.expand()

      unless deals.get('isLoading')
        observer()
      else
        deals.addObserver 'isLoading', observer

      false

    saveDealValue: (deal, value) ->
      deal.set 'value', value

      deal.save()

      false

    showNewDealModal: ->
      @set "showDealModal", true

      false

    closeDealModal: ->
      @set "deal", null

      @set "showDealModal", false

      false

    closeContactDrawer: ->
      @closeContactDrawer()

      false

    closeDealDrawer: ->
      @closeDealDrawer()

      false

    closeCompanyDrawer: ->
      @closeCompanyDrawer()

      false

    showDealDrawer: (deal) ->
      @closeDealDrawer()

      @set 'dealModel', deal

      config = {
        bindings: [{
          name: "deal",
          value: "dealModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeContactDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "showContactDrawer",
          value: "showContactDrawer",
          static: true
        },
        {
          name: "showCompanyDrawer",
          value: "showCompanyDrawer",
          static: true
        }
        ]
        component: 'x-deal'
      }

      @set 'dealParams', config

      @set 'showDealDrawer', true

      false

    showContactDrawer: (contact, hideMain) ->
      @closeContactDrawer()

      @set 'contactModel', contact

      config = {
        bindings: [{
          name: "contact",
          value: "contactModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeContactDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "addList",
          value: "addContactList",
          static: true
        },
        {
          name: "customFields",
          value: "customFields"
        },
        {
          name: "deleteContact",
          value: "deleteContact",
          static: true
        },
        {
          name: "hideMain",
          value: hideMain,
          static: true
        }
        ]
        component: 'x-contact'
      }

      @set 'contactParams', config

      @set 'showContactDrawer', true

      false

    showCompanyDrawer: (company, hideMain) ->
      @closeCompanyDrawer()

      @set "companyModel", company

      config = {
        bindings: [{
          name: "company",
          value: "drawerModel"
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
          value: hideMain,
          static: true
        }
        ],
        component: 'x-company'
      }

      @set 'companyParams', config

      @set 'showCompanyDrawer', true

      false

  combinedColumns: Ember.computed 'availableColumns.[]', ->
    savedColumns = JSON.parse(localStorage.getItem(@get('localStorageKey')))

    availableColumns = @get('availableColumns')

    cols = availableColumns.filter((c) -> savedColumns.contains(c.id))

    unless cols.length
      cols = cols.filter((c) => @get('initialColumns').contains(c.id))

    cols.setEach 'checked', true

    availableColumns

  checkedColumns: Ember.computed.filterBy 'combinedColumns', 'checked'

  classNames: ['single-column-container']

  filterStartDate: null
  filterEndDate: null

  showDealModal: false
  deal: null

  showDealDrawer: false
  dealModel: null
  dealParams: null

  showContactDrawer: false
  contactModel: null
  contactParams: null

  showCompanyDrawer: false
  companyModel: null
  companyParams: null

  localStorageKey: Ember.computed 'listType', ->
    "#{@SAVED_COLUMNS}_#{@get('listType')}"

  availableColumns: Ember.computed 'listType', ->
    @["#{@get('listType')}Columns"]

  initialColumns: Ember.computed 'listType', ->
    @["initial#{@get('listType').capitalize()}Columns"]

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @EventBus.subscribe "closeDrawers", this, @closeAllDrawers.bind(this)

    localStorageKey = @get('localStorageKey')

    @columnSelectionKey = localStorageKey

    storageData = localStorage.getItem(localStorageKey)

    existingData = if !storageData || storageData == "undefined" || storageData == "[]"
                     []
                   else
                     JSON.parse(storageData)

    unless existingData.length
      localStorage.setItem localStorageKey, JSON.stringify(@get("initialColumns"))

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @send 'loadMoreDeals'

  closeAllDrawers: ->
    @closeDealDrawer()
    @closeContactDrawer()
    @closeCompanyDrawer()

  closeDealDrawer: ->
    @set 'showDealDrawer', false
    @set 'dealModel', null
    @set 'dealParams', null

  closeContactDrawer: ->
    @set 'showContactDrawer', false
    @set 'contactModel', null
    @set 'contactParams', null

  closeCompanyDrawer: ->
    @set 'showCompanyDrawer', false
    @set 'companyModel', null
    @set 'companyParams', null
