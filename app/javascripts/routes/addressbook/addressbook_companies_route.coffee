Radium.AddressbookCompaniesRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      controller = @controllerFor 'addressbookCompanies'

      unless controller.get('allChecked') || controller.get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

      @render 'addressbook/deletion_confirmation',
        into: 'application',
        outlet: 'modal',

    close: ->
      @render 'nothing',
        into: 'application',
        outlet: 'modal'

  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Company
      params: {}
