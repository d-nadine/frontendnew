Radium.PeopleIndexRoute = Radium.Route.extend
  queryParams:
    user:
      refreshModel: true

  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'people.index'

    controller.send 'updateTotals'
    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    controller.set('user', params.user) if params.user

    controller.set 'filter', params.filter

    filterParams = controller.get('filterParams')

    p filterParams
    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: filterParams
