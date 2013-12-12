Radium.MessagesSearchRoute = Radium.Route.extend
  model: (params, transition) ->
    @controllerFor('messagesSidebar').set 'term', params.term
    @controllerFor('messagesSearch').set 'term', params.term
    Radium.EmailSearchResult.find(term: params.term)

  serialize: (model) ->
    folder: @controllerFor('messagesSearch').get('term')
