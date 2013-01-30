Radium.PipelineTableController = Em.ArrayController.extend Radium.ShowMoreMixin, Radium.CheckableMixin,
  contentBinding: 'pipelineController.content'
  perPage: 7
  deleteAll: ->
    # FIXME: ember-data errors, fake for now
    # @get('checkedContent').forEach (pipelineItem) ->
    #   pipelineItem.get('content').deleteRecord()

    # @get('store').commit()
    @get('content').setEach('isChecked', false)

    Radium.Utils.notify 'deleted!'

  deleteLead: (event) ->
    pipelineItem = event.context
    # FIXME: ember-data errors, fake for now
    # pipelineItem.get('content').deleteRecord()
    # @get('store').commit()

    pipelineItem.set 'isChecked', false
    Radium.Utils.notify "deleted!"

  valueTotal: ( ->
    return 0 unless @get('visibleContent.length')

    sum = @get('visibleContent').reduce (preVal, item) ->
      value = if preVal.constructor == Radium.PipelinePresenter
                value = preVal.get('value')
              else
                preVal

      value + (item.get('value') || 0)

    sum
  ).property('visibleContent', 'visibleContent.length')
