Radium.SidebarBaseController = Radium.ObjectController.extend
  actions:
    stopEditing: ->
      return if @get('isSaving')
      return unless @get('isValid')
      @send 'commit'
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

    commit: ->
      return unless @get('model')

      @send 'setProperties'

      model = @get('model')

      return unless model.get('isDirty')

      model.save(this).then (result) =>
        @send 'stopEditing'

      if @updateHook
        model.one 'didUpdate', (result) =>
          @updateHook(result)

      @get('store').commit()

  isEditable: true
  isEditing: false
