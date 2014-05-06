Radium.FlashController = Ember.Controller.extend
  type: null
  message: null

  errors: Ember.computed 'model', ->
    errors = @get('model.errors')
    return "" unless  errors

    for name, error of errors
                    "#{name}: #{error}"
