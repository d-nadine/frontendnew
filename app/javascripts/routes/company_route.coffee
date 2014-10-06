Radium.CompanyRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      @render 'company/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      company = @modelFor 'company'

      company.deleteRecord()

      name = company.get('name')

      company.one 'didDelete', =>
        @send 'closeModal'

        @send 'flashSuccess', "The company #{name} has been deleted"

        companiesDataset = @controllerFor('addressbookCompanies').get('model')

        companiesDataset.removeObject(company) if companiesDataset

        @transitionTo 'addressbook.companies'

        addressbookController = @controllerFor('addressbook')
        addressbookController.send('updateTotals') if addressbookController

      company.one 'becameInvalid', (result) ->
        result.reset()

      company.one 'becameError', (result) ->
        result.reset()

      @get('store').commit()

  renderTemplate: ->
    @render()
    @render 'company/sidebar',
      into: 'company'
      outlet: 'sidebar'
