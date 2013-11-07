Radium.PieChartComponent = Ember.Component.extend
  size: 100
  radius: 50
  dimension: null
  group: null
  renderLabel: true

  initChart: (->
    chart = dc.pieChart(@$()[0])
    @set('chart', chart)
    @renderChart()
  ).on('didInsertElement')

  renderChart: ->
    chart = @get 'chart'

    chart
      .width(@get('size'))
      .height(@get('size'))
      .radius(@get('radius'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .renderLabel(@get('renderLabel'))
    chart.render()

Ember.Handlebars.helper 'pie-chart', Radium.PieChartComponent