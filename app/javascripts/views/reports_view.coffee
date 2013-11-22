Radium.ReportsView = Ember.View.extend
  init: ->
    @set('charts', [])
    @_super()
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  classNameBindings: 'isFilterPinned:pin-filter'

  didInsertElement: ->
    $filter = @$('#master-filter')
    filterTop = $filter.offset().top
    filterHeight = $filter.height()
    @set 'mainFilterOffset', filterTop - filterHeight
    $(window).on 'scroll.reports', @reportsScrollHandler.bind(this)

  willDestroyElement: ->
    $(window).off 'scroll.reports'

  reportsScrollHandler: ->
    top = $(window).scrollTop()
    offset = @get 'mainFilterOffset'
    
    if (top > offset)
      @set 'isFilterPinned', true
    else
      @set 'isFilterPinned', false

  registerChart: (chart) ->
    @get('charts').pushObject chart

  removeChart: (chart) ->
    @get('charts').removeObject chart

  updateCharts: (->
    startDate = @get('controller.startDate').toJSDate()
    endDate = @get('controller.endDate').toJSDate()

    @get('charts').forEach((chart) =>
      chart.focus([startDate, endDate])
    )
  ).observes('controller.startDate', 'controller.endDate')