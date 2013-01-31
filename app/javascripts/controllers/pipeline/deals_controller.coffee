Radium.PipelineDealsControllerBase = Radium.PipelineBaseController.extend
  valueTotal: ( ->
    return 0 unless @get('visibleContent.length')

    sum = @get('visibleContent').reduce (preVal, item) ->
      value = if preVal.constructor == Radium.Deal
                value = preVal.get('value')
              else
                preVal

      value + (item.get('value') || 0)

    sum
  ).property('visibleContent', 'visibleContent.length')
