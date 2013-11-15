Radium.ReportsView = Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  classNameBindings: 'isFilterPinned:pin-filter'

  didInsertElement: ->
    filter = @$('#master-filter')
    filterTop = filter.offset().top
    filterHeight = filter.height()
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