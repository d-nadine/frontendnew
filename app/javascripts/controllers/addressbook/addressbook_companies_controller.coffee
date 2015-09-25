require "controllers/addressbook/people_mixin"
require "controllers/addressbook/companies_columns_config"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.CompaniesColumnConfig,
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
      false

    updateTotals: ->
      @get('addressBookController').send 'updateTotals'

  needs: ['addressbook', 'users', 'tags']

  addressBookController: Ember.computed.oneWay 'controllers.addressbook'

  public: true
