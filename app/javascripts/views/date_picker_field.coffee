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
    # jQuery UI doesn't seem to want to get rid of this
    $('#ui-datepicker-div').hide()

    # TODO: uncommenting next line causes an error, to investigate
    # @$().datepicker 'destroy'

  focusOut: ->
    @_super()
    @set 'value', @get('_cachedDate')  if @get('value') is ''
