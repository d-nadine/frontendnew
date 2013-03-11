Radium.PipelineBaseController = Radium.ArrayController.extend Radium.ShowMoreMixin, Radium.CheckableMixin,
  perPage: 7
  activeForm: null

  showTodoForm: Radium.computed.equal('activeForm', 'todo')
  showCallForm: Radium.computed.equal('activeForm', 'call')

  hasActiveForm: Radium.computed.isPresent('activeForm')

  showForm: (form) ->
    @set 'activeForm', form

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('checkedContent')
  ).property('checkedContent.[]', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')
  ).property('model.[]', 'tomorrow')

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
