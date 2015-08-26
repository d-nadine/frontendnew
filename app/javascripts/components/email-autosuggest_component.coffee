require "components/async-autosuggest_component"

Radium.EmailAutosuggestComponent = Radium.AsyncAutosuggestComponent.extend
  queryParameters: (query) ->
    term: query
    email_only: true

  filterResults: (item) ->
    return false if @get('destination').mapProperty('id').contains(item.get('id'))
    return false if item.get('type') != 'list' && !item.get('email')

    true
