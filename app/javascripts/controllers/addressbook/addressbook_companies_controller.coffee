require "controllers/addressbook/people_mixin"
require "controllers/addressbook/companies_columns_config"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.CompaniesColumnConfig,

  actions:
    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

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

  needs: ['addressbook', 'users', 'tags']
