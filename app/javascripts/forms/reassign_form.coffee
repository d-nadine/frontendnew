require 'forms/form'

Radium.ReassignForm = Radium.Form.extend
  isValid: ( ->
    @get('assignToUser')
  ).property('user')

  commit: ->
    @get('selectedContent').forEach (item) =>
      item.set('user', @get('assignToUser'))

    @get('store').commit()
