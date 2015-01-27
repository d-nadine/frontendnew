Radium.LeadsUntrackedRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      controller = @controllerFor 'leadsUntracked'

      unless controller.get('allChecked') || controller.get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

      @render 'leads/deletion_confirmation',
        into: 'application',
        outlet: 'modal',

    close: ->
      @render 'nothing',
        into: 'application',
        outlet: 'modal'

  model: ->
    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: {private: true}
