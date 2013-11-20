require 'mixins/components/chart_component_mixin'

Radium.BarChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'barChart'
  width: null
  height: 100
  domain: [0, 1]

  refresh: ->
    @get('chart').refresh()

  renderChart: ->
    chart = @get 'chart'
    domain = @get 'domain'
    valueAccessor = @get 'valueAccessor'
    width = @get('width')

    componentWidth = if width then width else @$().parent().width()

    chart
      .width(componentWidth)
      .height(@get('height'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .x(d3.time.scale().domain(domain))
      .round(d3.time.month.round)
      .xUnits(d3.time.months)
      .valueAccessor((d) -> d.value[valueAccessor])
      .renderLabel(@get('renderLabel'))

    chart.on('filtered', (chart, filter) =>
      setFilter = if filter then filter else null
      @sendAction('action', setFilter)
    )
    chart.render()