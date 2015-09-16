Radium.ListRoute = Ember.Route.extend
  beforeModel: (transition) ->
    controller = @controllerFor('list')

    listId = transition.params['list'].list_id

    controller = @controllerFor 'list'

    # UPGRADE: use handlebars subexpression to create dataset
    controller.set 'deals', Radium.InfiniteDataset.create
      type: Radium.Deal
      params: @filterParams(listId)

  filterParams: (listId) ->
    list: listId
    page_size: 10
