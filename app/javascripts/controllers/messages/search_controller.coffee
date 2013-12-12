Radium.MessagesSearchController = Radium.ArrayController.extend
  term: null
  actions:
    search: ->
      term = @get('term')

      return unless term.length

      Radium.EmailSearchResult.find term: term
      false
