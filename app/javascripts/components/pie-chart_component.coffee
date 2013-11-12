require 'mixins/components/chart_component_mixin'

Radium.PieChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'pieChart'
  size: 100
  radius: 50

  refresh: ->
    @get('chart').refresh()

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