require 'mixins/components/chart_component_mixin'

Radium.PieChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'pieChart'
  classNames: 'pie-chart'
  classNameBindings: ['uniqueClass']
  radius: 50
  # possible title formats: 'default', 'money'
  valueFormat: 'default'

  uniqueClass: Ember.computed ->
    "pie-chart-#{@get('radius')}"

  style: Ember.computed ->
    """<style type='text/css'>
      
      .pie-chart.#{@get('uniqueClass')} svg {
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
      accounting.formatMoney(object.value)

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
    chart.on('filtered', @setFilter.bind(this))

    chart.render()