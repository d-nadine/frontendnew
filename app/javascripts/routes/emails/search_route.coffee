Radium.MessagesSearchRoute = Radium.Route.extend
  model: (params, transition) ->
    Radium.EmailSearchResult.find(term: params.term)

  serialize: (model) ->
    folder: @controllerFor('messagesSearch').get('term')
