Radium.ChartComponentMixin = Ember.Mixin.create
  dimension: null
  group: null
  renderLabel: true

  initChart: (->
    type = @get 'type'
    window.c = chart = dc[type](@$()[0])
    
    @set('chart', chart)
    @renderChart()
  ).on('didInsertElement')