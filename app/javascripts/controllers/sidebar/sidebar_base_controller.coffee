Radium.SidebarBaseController = Radium.ObjectController.extend
  isEditable: true
  isEditing: false

  stopEditing: ->
    return if @get('isSaving')
    return unless @get('isValid')
    @commit()
    @set 'isEditing', false

  startEditing: ->
    return if @get('isSaving')
    @set 'isEditing', true
    @get('form').reset()
    @setForm()

  setProperties: ->
    return unless @get('model')

    @get('model').setProperties(@get('form').getProperties(@get('form.properties')))

  commit: ->
    return unless @get('model')

    @setProperties()

    model = @get('model')

    return unless model.get('isDirty')

    model.one 'becameInvalid', (result) ->
      Radium.Utils.generateErrorSummary result

    model.one 'bacameError', ->
      Radium.Utils.notifyError 'An error has occurred and the update did not occurr.'

    @get('store').commit()
