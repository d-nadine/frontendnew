Radium.Form = Ember.ObjectProxy.extend
  isEditable: true
  defaults: {}

  init: ->
    if @get('isNew')
      @get('content').setProperties @get('defaults')

  reset: ->
    @get('content').setProperties @get('defaults')

  isValid: ( ->
    throw new Error('subclasses of form must override isValid')
  ).property()

  data: ( ->
    throw new Error('subclasses of form must override data')
  ).property().volatile()
