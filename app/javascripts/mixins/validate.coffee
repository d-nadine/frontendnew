Radium.Validate = Ember.Mixin.create(
  # Requires a controller attached to the parent view.
  classNameBindings: ['isInvalid:is-error', 'isValid']
  didInsertElement: ->
    @get('controller.invalidFields').pushObject this
    @$().before '<span class=\'required\'>*</span>'

  keyUp: (event) ->
    @_super event
    @runValidation()

  focusOut: (event) ->
    @_super event
    @runValidation()

  checkValue: (->
    @runValidation()
  ).observes('value')

  runValidation: ->
    invalidFields = @get('controller.invalidFields')
    if @validate()
      @setProperties
        isInvalid: false
        isValid: true

      invalidFields.removeObject this
    else
      @setProperties
        isInvalid: true
        isValid: false

      invalidFields.pushObject this  if invalidFields.indexOf(this) is -1
)
