require "controllers/addressbook/people_mixin"
require "controllers/addressbook/companies_columns_config"
require "mixins/common_drawer_actions"
require "mixins/table_column_selections"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.CompaniesColumnConfig,
  Radium.CommonDrawerActions,
  Radium.TableColumnSelectionsMixin,
  actions:
    showAddCompany: ->
      $('.new-company').slideToggle('medium', ->
        Ember.$('.new-company input[type=text]').focus()
      )

    assignAll: (user) ->
      detail =
        user: user
        jobType: Radium.CompaniesBulkAction
        modelType: Radium.Company

      @send "executeActions", "assign", detail

      false

    deleteAll: ->
      detail =
        jobType: Radium.CompaniesBulkAction
        modelType: Radium.Company

      @send "executeActions", "delete", detail

      @set "showDeleteConfirmation", false

      false

    updateTotals: ->
      @get('addressBookController').send 'updateTotals'

      false

    confirmDeletion: ->
      unless @get('allChecked') || @get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

      @set "showDeleteConfirmation", true

      false

  needs: ['addressbook', 'users']

  checkedColumns: Ember.computed.filterBy 'combinedColumns', 'checked'

  combinedColumns: Ember.computed 'columns.[]', ->
    columns = @get('columns')

    savedColumns = JSON.parse(localStorage.getItem(@SAVED_COLUMNS))

    # FIXME: add custom fields to columns
    combined = columns

    cols = combined.filter((c) -> savedColumns.contains(c.id))

    unless cols.length
      cols = combined.filter((c) => @initialColumns.contains(c.id))

    cols.setEach 'checked', true

    combined

  addressBookController: Ember.computed.oneWay 'controllers.addressbook'

  public: true

  showDeleteConfirmation: false

  closeDrawer: ->
    return if @isDestroyed || @isDestroying
    @set 'showDrawer', false
    @set 'drawerModel', null
    @set 'drawerParams', null

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @EventBus.subscribe "closeDrawers", this, @closeDrawer.bind(this)

    @columnSelectionKey = @SAVED_COLUMNS

    storageData = localStorage.getItem(@SAVED_COLUMNS)

    existingData = if !storageData || storageData == "undefined" || storageData == "[]"
                     []
                   else
                     JSON.parse(storageData)

    unless existingData.length
      localStorage.setItem @SAVED_COLUMNS, JSON.stringify(@get("initialColumns"))
