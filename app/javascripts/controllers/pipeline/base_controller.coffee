Radium.PipelineBaseController = Radium.ArrayController.extend Radium.ShowMoreMixin, Radium.CheckableMixin,
  perPage: 7

  openMenu: (menu) ->
    alert menu

  deleteAll: ->
    # FIXME: ember-data errors, fake for now
    # @get('checkedContent').forEach (pipelineItem) ->
    #   pipelineItem.get('content').deleteRecord()

    # @get('store').commit()
    @get('content').setEach('isChecked', false)

    Radium.Utils.notify 'deleted!'

  deleteObject: (pipelineItem) ->
    # FIXME: ember-data errors, fake for now
    # pipelineItem.get('content').deleteRecord()
    # @get('store').commit()

    pipelineItem.set 'isChecked', false
    Radium.Utils.notify "deleted!"
