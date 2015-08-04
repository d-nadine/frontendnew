Radium.CompanyRoute = Radium.Route.extend
  actions:
    confirmCompanyDeletion: ->
      @render 'company/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      company = @modelFor 'company'

      name = company.get('name')

      company.delete().then =>
        @send 'closeModal'

        @send 'flashSuccess', "The company #{name} has been deleted"

        companiesDataset = @controllerFor('addressbookCompanies').get('model')

        companiesDataset.removeObject(company) if companiesDataset

        @transitionTo 'addressbook.companies'

        addressbookController = @controllerFor('addressbook')
        addressbookController.send('updateTotals') if addressbookController
