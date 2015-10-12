require 'components/deal_columns_config'
require "mixins/table_column_selections"
require "mixins/common_drawer_actions"
require "controllers/addressbook/people_mixin"

Radium.XListComponent = Ember.Component.extend Radium.DealColumnsConfig,
  Radium.TableColumnSelectionsMixin,
  Radium.CommonDrawerActions,
  Radium.PeopleMixin,

  actions:
    afterContactSave: (component) ->
      deal = component.get('deal')
      contact = component.get('model')

      func = ->
        # deal.one 'didReload', (deal) ->
        deal.set('contact', null)
        deal.set('contact', contact)

        deal.save().then ->
          deal.updateLocalBelongsTo('contact', contact)

      deal.executeWhenInCleanState func

      false

    updateTotals: ->
      @set "showDeleteConfirmation", false

      Radium.DealTotal.find(list: @get('list.id')).then (results) =>
        totals = results.get('firstObject')
        @set 'listTotalValue', totals.get('value')

      false

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

    assignAll: (user) ->
      detail =
        user: user
        jobType: Radium.DealsBulkAction
        modelType: Radium.Deal

      @send "executeActions", "assign", detail
      false

    confirmDeletion: ->
      unless @get('allChecked') || @get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

      @set "showDeleteConfirmation", true

      false

    deleteAll: ->
      detail =
        jobType: Radium.DealsBulkAction
        modelType: Radium.Deal

      @send "executeActions", "delete", detail

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

  showDeleteConfirmation: false

  arrangedContent: Ember.computed.oneWay 'deals'
  model: Ember.computed.oneWay 'deals'

  users: Ember.computed ->
    @container.lookup('controller:users')

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
    @EventBus.subscribe 'closeListDrawers', this, 'closeAllDrawers'
    @send 'updateTotals'

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @EventBus.unsubscribe 'closeListDrawers'
    @closeAllDrawers()

  likeNessQuery: ->
    searchText = @get('searchText')

    filterParams = @get('filterParams') || {}

    params = Ember.merge filterParams, like: searchText, page_size: @get('pageSize')

    @get("deals").set("params", Ember.copy(params))
