Radium.PeopleIndexRoute = Radium.Route.extend
  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    params = controller.get('paramsMap')[params.filter]

    params = Ember.merge params, page_size: controller.get('pageSize')

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: params
