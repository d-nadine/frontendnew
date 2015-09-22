Radium.ListRoute = Ember.Route.extend
  afterModel: (model, transition) ->
    controller = @controllerFor('list')

    listId = model.get('id')

    Ember.assert "No list id in ListRoute", listId

    controller = @controllerFor 'list'

    # UPGRADE: use handlebars subexpression to create dataset
    controller.set 'deals', Radium.InfiniteDataset.create
      type: Radium.Deal
      params: @filterParams(listId)

  filterParams: (listId) ->
    list: listId
    page_size: 10
