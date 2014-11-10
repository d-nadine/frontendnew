Radium.PeopleIndexRoute = Radium.Route.extend
  model: (params) ->
    params = @controllerFor('peopleIndex').get('paramsMap')[params.filter]

    params = Ember.merge params, page_size: 15

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: params
