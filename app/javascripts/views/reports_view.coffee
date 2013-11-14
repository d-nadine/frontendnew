Radium.ReportsView = Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  classNameBindings: 'isFilterPinned:pin-filter'

  didInsertElement: ->
    @set 'mainFilterOffset', @$('#master-filter').offset().top
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