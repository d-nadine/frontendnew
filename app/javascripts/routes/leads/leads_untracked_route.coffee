Radium.UntrackedIndexRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      controller = @controllerFor 'untrackedIndex'

      unless controller.get('allChecked') || controller.get('checkedContent.length')
        return @send 'flashError', "You have not selected any items."

      @render 'leads/deletion_confirmation',
        into: 'application',
        outlet: 'modal',

    close: ->
      @render 'nothing',
        into: 'application',
        outlet: 'modal'

  beforeModel: (transition) ->
    filter = transition.params['untracked.index'].filter

    controller = @controllerFor 'untracked.index'

    controller.send 'updateTotals'
    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'untrackedIndex'

    controller.set 'filter', params.filter

    filterParams = controller.get('filterParams')

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: filterParams
