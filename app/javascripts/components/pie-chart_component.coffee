require 'mixins/components/chart_component_mixin'

Radium.PieChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'pieChart'
  size: 100
  classNames: 'pie-chart'
  radius: 50

  setFilter: (chart, filter) ->
    currentFilter = @get('_currentFilter')

    if filter is currentFilter
      @sendAction('action', null)
    else 
      @sendAction('action', filter)
      @set('_currentFilter', filter)
      
  refresh: ->
    @get('chart').refresh()

  renderChart: ->
    chart = @get 'chart'

    chart
      .width(@get('radius')*2)
      .height(@get('radius')*2)
      .radius(@get('radius'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .renderLabel(false)
      .legend(dc.legend().x((@get('radius')*2) + 10).y(10))

    chart.on('filtered', @setFilter.bind(this))

    chart.render()