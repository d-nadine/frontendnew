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

      @get('model').setProperties(@get('form').getProperties(@get('form.properties')))

    commit: ->
      return unless @get('model')

      @send 'setProperties'

      model = @get('model')

      return unless model.get('isDirty')

      model.one 'becameInvalid', (result) ->
        @send 'flashError', result

      model.one 'bacameError', ->
        @send 'flashError', 'An error has occurred and the update did not occurr.'

      @get('store').commit()

  isEditable: true
  isEditing: false
