require 'controllers/pipeline/base_controller'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend
  total: ( ->
    return 0 unless @get('visibleContent.length')

    sum = @get('visibleContent').reduce (preVal, item) ->
      value = if preVal.get
                value = preVal.get('value')
              else
                preVal

      value + (item.get('value') || 0)

    sum
  ).property('visibleContent', 'visibleContent.length')
