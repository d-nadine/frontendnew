require "controllers/addressbook/people_mixin"
require "controllers/addressbook/companies_columns_config"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.CompaniesColumnConfig,

  actions:
    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

  needs: ['addressbook', 'users', 'tags']
