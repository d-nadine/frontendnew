Radium.Form = Ember.ObjectProxy.extend
  defaults: {}

  init: ->
    @reset()

  reset: ->
    return unless @get('isNew')
    @get('content').setProperties @get('defaults')

  data: ( ->
    throw new Error('subclasses of form must override data')
  ).property().volatile()
