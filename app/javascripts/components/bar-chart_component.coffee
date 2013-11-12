require 'mixins/components/chart_component_mixin'

Radium.BarChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'barChart'
  width: 100
  height: 100

  refresh: ->
    @get('chart').refresh()

  renderChart: ->
    chart = @get 'chart'

    chart
      .width(@get('width'))
      .height(@get('height'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .x(d3.scale.linear().domain([0, 5000]))
      .renderLabel(@get('renderLabel'))
    chart.render()

Ember.Handlebars.helper 'bar-chart', Radium.BarChartComponent