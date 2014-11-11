Radium.PeopleIndexRoute = Radium.Route.extend
  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'people.index'

    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    params = controller.get('filterParams')

    p params
  
    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: params
