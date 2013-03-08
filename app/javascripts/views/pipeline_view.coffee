Radium.PipelineView = Ember.View.extend
  layoutName: 'layouts/single_column'

  classNames: ['page-view']

  statusDidChange: ( ->
    currentStatus = @get('controller.currentStatus.status')

    return unless currentStatus

    element = @$("a:contains('#{currentStatus}')")

    return unless element && element.offset()

    $('html, body').animate({
      scrollTop: element.offset().top
    }, 800)
  ).observes('controller.currentStatus')
