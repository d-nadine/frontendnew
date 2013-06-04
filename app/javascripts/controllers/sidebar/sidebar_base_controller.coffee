Radium.SidebarBaseController = Radium.ObjectController.extend
  isEditing: false
  commit: ->
    model = @get('model')
    model.setProperties(@get('form').getProperties(@get('form.properties')))

    return unless model.get('isDirty')

    @get('store').commit()

    model.one 'becameInvalid', ->
      alert model.get('errors.length')

    model.one 'bacameError', ->
      alert model.get('errors.length')


