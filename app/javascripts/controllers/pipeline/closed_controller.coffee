require 'controllers/pipeline/deals_controller'

Radium.PipelineClosedController = Radium.PipelineDealsController.extend
  title: 'Closed'
  showPastDateRange: true
  showFutureDateRange: false

  dateFilteredContent: Ember.computed 'content.[]', 'filterStartDate', 'filterEndDate', ->
    content = @get('content')

    content.filter (item) =>
      return true unless @get("filterStartDate")? and @get("filterEndDate")?
      closeDate = item.get("statusLastChangedAt._ms")
      startDate = @get("filterStartDate").getTime()
      endDate = @get("filterEndDate").getTime()
      return !closeDate? || (startDate <= closeDate && closeDate <= endDate)
