Radium.SidebarBaseController = Radium.ObjectController.extend
  actions:
    stopEditing: ->
      return if @get('isSaving')
      return unless @get('isValid')
      @send('commit') unless @get('isCommitting')
      @set 'isEditing', false

    startEditing: ->
      return if @get('isSaving')
      @set 'isEditing', true
      @get('form').reset()
      @send 'setForm'

    setProperties: ->
      return unless @get('model')

      properties = @get('form').getProperties(@get('form.properties'))
      model = @get('model')

      model.setProperties(properties)

    commit: (continueEditing) ->
      return unless @get('model')

      return if @get('isCommitting')

      @send 'setProperties'

      model = @get('model')

      return unless model.get('isDirty')

      @set 'isCommitting', true

      model.save(this).then((result) =>
        @send 'stopEditing' unless continueEditing
        @set 'isCommitting', false
      ).catch (result) =>
        @set('isCommitting', false)

      if @updateHook
        model.one 'didUpdate', (result) =>
          @updateHook(result)

  isEditable: true
  isEditing: false
