Radium.CompanyRoute = Radium.Route.extend
  actions:
    deleteRecord: (company) ->
      name = company.get('name')

      company.delete().then =>
        @send 'closeModal'

        @send 'flashSuccess', "The company #{name} has been deleted"

        companiesDataset = @controllerFor('addressbookCompanies').get('model')

        companiesDataset.removeObject(company) if companiesDataset

        @transitionTo 'addressbook.companies'

        addressbookController = @controllerFor('addressbook')
        addressbookController.send('updateTotals') if addressbookController
