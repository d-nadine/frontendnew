require 'mixins/components/chart_component_mixin'

Radium.BarChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'barChart'
  width: null
  height: 100
  classNames: 'bar-chart'
  domain: [0, 1]

  refresh: ->
    @get('chart').refresh()

  resize: ->
    width = @$().parent().width()
    @get('chart').width(width).render()

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

    chart.on('filtered', _.debounce((chart, filter) =>
      @sendAction('action', filter)
    ), 100)

    chart.render()
    
    $(window).on('resize', _.debounce(@resize.bind(this), 50).bind(this))