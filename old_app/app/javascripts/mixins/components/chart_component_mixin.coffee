Radium.ChartComponentMixin = Ember.Mixin.create
  dimension: null
  group: null
  renderLabel: true
  classNames: 'radium-chart'

  initChart: (->
    type = @get 'type'
    window.c = chart = dc[type](@$()[0])
    
    @set('chart', chart)
    @renderChart()
  ).on('didInsertElement')

  actions:
    reset: ->
      @get('chart').filterAll()
      dc.redrawAll()