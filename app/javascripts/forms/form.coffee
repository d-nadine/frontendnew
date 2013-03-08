Radium.Form = Ember.ObjectProxy.extend
  defaults: {}

  init: ->
    @reset()

  reset: ->
    return unless @get('isNew')
    @get('content').setProperties @get('defaults')

  isValid: ( ->
    throw new Error('subclasses of form must override isValid')
  ).property()

  data: ( ->
    throw new Error('subclasses of form must override data')
  ).property().volatile()
