Radium.Form = Ember.ObjectProxy.extend
  defaults: {}

  init: ->
    if @get('isNew')
      @setProperties @get('defaults')

  reset: ->
    @setProperties @get('defaults')

  isValid: ( ->
    throw new Error('subclasses of form must override isValid')
  ).property()

  data: ( ->
    throw new Error('subclasses of form must override data')
  ).property().volatile()
