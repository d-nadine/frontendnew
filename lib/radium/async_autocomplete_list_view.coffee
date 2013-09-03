require 'lib/radium/autocomplete_list_view'

Radium.AsyncAutocompleteView = Radium.AutocompleteView.extend
  queryParameters: (query) ->
    term: query

  retrieve: (query, callback) ->
    queryParameters = @get('parentView').queryParameters(query)

    Radium.AutocompleteItem.find(queryParameters).then((people) =>
      results = people.filter(@get('parentView').filterResults.bind(this))
                     .map (item) =>
                        return false unless item.get('email')
                        @mapSearchResult.call this, item

      callback(results, query)
    ).then(null, Radium.rejectionHandler)

Radium.EmailAsyncAutocompleteView = Radium.AsyncAutocompleteView.extend
  filterResults: (item) ->
    !@get('source').contains(item) && item.get('email')
