Radium.Form = Ember.ObjectProxy.extend
  isValid: ( ->
    throw new Error('subclasses of form must override isValid')
  ).property()

  data: ( ->
    throw new Error('subclasses of form must override data')
  ).property().volatile()
