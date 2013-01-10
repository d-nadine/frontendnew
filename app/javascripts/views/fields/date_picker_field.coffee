Radium.DatePickerField = Ember.TextField.extend
  placeholder: ''
  attributeBindings: ['name']
  minDate: new Date()

  didInsertElement: ->
    @set '_cachedDate', @get('value')
    @$().datepicker
      dateFormat: 'yy-mm-dd'
      minDate: @get('minDate')
      constrainInput: true

  willDestroyElement: ->
    @$().datepicker 'destroy'

  focusOut: ->
    @_super()
    @set 'value', @get('_cachedDate')  if @get('value') is ''
