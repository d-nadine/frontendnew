require 'forms/form'

Radium.CallForm = Radium.Form.extend
  canChangeContact: true

  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
    reference: @get('reference')
  ).property().volatile()

  isValid: ( ->
    return unless @get('reference')
    return if Ember.isEmpty(@get('description'))
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true
  ).property('reference', 'description', 'finishBy', 'user')
