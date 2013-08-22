require 'lib/radium/autocomplete_list_view'

Radium.AsyncAutocompleteView = Radium.AutocompleteView.extend
  retrieve: (query, callback) ->
    Radium.AutocompleteItem.find(term: query).then((people) =>
      results = people.filter(@get('parentView').filterResults.bind(this))
                     .map (item) =>
                        @mapSearchResult.call this, item

      callback(results, query)
    ).then(null, Radium.rejectionHandler)

Radium.EmailAsyncAutocompleteView = Radium.AsyncAutocompleteView.extend
  filterResults: (item) ->
    !@get('source').contains(item) && item.get('email')
