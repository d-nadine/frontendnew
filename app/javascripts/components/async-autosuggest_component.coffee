require "components/x-autosuggest_component"

Radium.AsyncAutosuggestComponent = Radium.XAutosuggestComponent.extend
  queryParameters: (query) ->
    term: query

  retrieve: (query, callback) ->
    queryParameters = @get('targetObject').queryParameters(query)

    keys = Ember.A()

    Radium.AutocompleteItem.find(queryParameters).then((people) =>
      results = people.filter(@get('targetObject').filterResults.bind(this))
                     .map (item) =>
                        return false unless item.get('name') || item.get('email') || item.get('isTag')
                        return false if keys.map((key) -> key.key).contains(item.get('key').key || "#{item.get('email')} - user")
                        keys.push(item.get('key'))
                        @mapSearchResult.call this, item

      callback(results, query)
   )
