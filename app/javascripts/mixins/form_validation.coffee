Radium.FormValidation = Ember.Mixin.create
  init: ->
    @_super()
    @set 'invalidFields', Ember.A([])

  isInvalid: (->
    (if (@get('invalidFields.length')) then true else false)
  ).property('invalidFields.length')
