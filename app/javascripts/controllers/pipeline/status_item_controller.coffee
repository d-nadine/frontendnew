Radium.StatusItemController = Em.ObjectController.extend
  needs: ['pipeline']

  statusDidChange: ( ->
    status = @get('controllers.pipeline.currentStatus.status')

    return unless status

    @set('isExpanded', @get('status') == status)
  ).observes('controllers.pipeline.currentStatus')

  percentage: ( ->
    total = @get('controllers.pipeline.customStatusesTotal')

    return 0 unless total || total == 0 || status.get('deals.length') == 0

    Math.floor((@get('deals.length') / total) * 100)
  ).property('deals', 'deals.length')

  expand: ->
    @toggleProperty 'isExpanded'

  total: ( ->
    sum = @get('deals').reduce (preVal, item) ->
      value = if preVal.get
                value = preVal.get('value')
              else
                preVal

      value + (item.get('value') || 0)

    sum
  ).property('deals', 'deals.length')

  title: ( ->
    "#{@get('status')} - (#{@get('deals.length')})"
  ).property('status', 'deals.length')
