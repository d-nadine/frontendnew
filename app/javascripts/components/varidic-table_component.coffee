Radium.VaridicTableComponent = Ember.Component.extend
  actions:
    showMore: ->
      @sendAction 'showMore'
      return false

    sortTable: (prop, ascending) ->
      @sendAction 'sort', prop, ascending
      return false

  colSpan: Ember.computed 'columns.length', ->
    @get('columns.length') + 1
