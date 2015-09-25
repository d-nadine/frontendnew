require "controllers/addressbook/people_mixin"
require "controllers/addressbook/companies_columns_config"
require "mixins/common_drawer_actions"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.CompaniesColumnConfig,
  Radium.CommonDrawerActions,
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

      # need to call a better update companies
      Ember.run.next =>
        @container.lookup('route:addressbookCompanies').refresh()

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

  addressBookController: Ember.computed.oneWay 'controllers.addressbook'

  public: true

  showDeleteConfirmation: false
