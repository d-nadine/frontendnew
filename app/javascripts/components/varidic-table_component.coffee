Radium.VaridicTableComponent = Ember.Component.extend
  actions:
    showMore: ->
      @sendAction 'showMore'

  colSpan: Ember.computed 'columns.length', ->
    @get('columns.length') + 1
