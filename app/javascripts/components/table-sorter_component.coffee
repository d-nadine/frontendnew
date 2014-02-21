Radium.TableSorterComponent = Ember.Component.extend
  ascending: true
  actions:
    sort: ->
      @toggleProperty 'ascending'
      @sendAction 'sort', @get('sortOn'), @get('ascending')
      false
