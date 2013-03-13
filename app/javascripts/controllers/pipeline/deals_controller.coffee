require 'controllers/pipeline/base_controller'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend
  total: ( ->
    return 0 unless @get('visibleContent.length')

    sum = 0

    @get('visibleContent').forEach (item) ->
      sum += item.get('value')

    sum
  ).property('visibleContent.[]')
