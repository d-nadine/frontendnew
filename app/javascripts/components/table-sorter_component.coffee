Radium.TableSorterComponent = Ember.Component.extend
  ascending: true
  actions:
    sort: ->
      @toggleProperty 'ascending'
      @sendAction 'sort', @get('sortOn'), @get('ascending')
      false

  setup: Ember.on 'didInsertElement', ->
    if @get('initialDesc')
      @set 'ascending', false
    else
      @set 'ascending', true
