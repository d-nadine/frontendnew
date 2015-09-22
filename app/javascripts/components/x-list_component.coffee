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

    closeListDrawer: ->
      @closeDrawer()

      false

    showDealDrawer: (deal) ->
      @closeDrawer()

      @set 'drawerModel', deal

      config = {
        bindings: [{
          name: "deal",
          value: "drawerModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeListDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        }
        ]
        component: 'x-deal'
      }

      @set 'drawerParams', config

      @set 'showDrawer', true

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
  showDrawer: false
  drawerModel: null
  drawerParams: null

  localStorageKey: Ember.computed 'listType', ->
    "#{@SAVED_COLUMNS}_#{@get('listType')}"

  availableColumns: Ember.computed 'listType', ->
    @["#{@get('listType')}Columns"]

  initialColumns: Ember.computed 'listType', ->
    @["initial#{@get('listType').capitalize()}Columns"]

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @EventBus.subscribe "closeDrawers", this, @closeDrawer.bind(this)

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

  closeDrawer: ->
    @set 'showDrawer', false
    @set 'drawerModel', null
    @set 'drawerParams', null
