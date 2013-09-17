require 'lib/radium/autocomplete_list_view'

Radium.AsyncAutocompleteView = Radium.AutocompleteView.extend
  queryParameters: (query) ->
    term: query

  retrieve: (query, callback) ->
    queryParameters = @get('parentView').queryParameters(query)

    keys = Ember.A()

    Radium.AutocompleteItem.find(queryParameters).then((people) =>
      results = people.filter(@get('parentView').filterResults.bind(this))
                     .map (item) =>
                        return false unless item.get('email')
                        return false if keys.map((key) => key.key).contains(item.get('key').key || "#{item.get('email')} - user")
                        keys.push(item.get('key'))
                        @mapSearchResult.call this, item

      callback(results, query)
    ).then(null, Radium.rejectionHandler)

Radium.EmailAsyncAutocompleteView = Radium.AsyncAutocompleteView.extend
  queryParameters: (query) ->
    term: query
    email_only: true

  filterResults: (item) ->
    !@get('source').contains(item) && item.get('email')
