require 'mixins/components/chart_component_mixin'

Radium.PieChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'pieChart'
  classNames: 'pie-chart'
  radius: 50
  # possible title formats: 'default', 'money'
  valueFormat: 'default'

  style: Ember.computed ->
    """<style type='text/css'>
      ##{Ember.guidFor(this)} svg {
        width: #{(@get('radius')*2) + 150}px;
      }
    </style>"""
  setFilter: (chart, filter) ->
    currentFilter = @get('_currentFilter')

    if filter is currentFilter
      @sendAction('action', null)
    else 
      @sendAction('action', filter)
      @set('_currentFilter', filter)
      
  refresh: ->
    @get('chart').refresh()

  formattedValue: (object) ->
    if @get('valueFormat') == 'default'
      object.value
    else if @get('valueFormat') == 'money'
      accounting.formatMoney(object.value['closed_total'])

  formattedTitle: (titleObject) ->
    "#{titleObject.key}: #{@formattedValue(titleObject)}"
    
  renderChart: ->
    chart = @get 'chart'

    chart
      .width(@get('radius')*2)
      .height(@get('radius')*2)
      .radius(@get('radius'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .label((d) => @formattedValue(d))
      .legend(dc.legend().x((@get('radius')*2) + 10).y(10))
      .title((d) => @formattedTitle(d))
      .valueAccessor((d) -> d.value['closed_total'])

    chart.on('filtered', @setFilter.bind(this))

    chart.render()
