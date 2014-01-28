Radium.TimePickerView = Radium.View.extend
  actions:
    showTimePicker: ->
      return if @get('disabled')

      unless @get('isOpen')
        @$('.timepicker').trigger('click.timepicker')

      Ember.run.next =>
        @toggleProperty('isOpen')

      event.stopPropagation()
      event.preventDefault()

  templateName: 'forms/time_picker'
  classNameBindings: [
    'date:is-valid'
    'disabled:is-disabled'
    'isInvalid'
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':timepicker'
    ':input-append'
  ]
  isOpen: false

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  leader: null

  disabled: Ember.computed.alias('controller.isDisabled')

  textBinding: 'textToTimeTransform'

  textToTimeTransform: ((key, value) ->
    if arguments.length == 2
      if value && /^(0?[1-9]|1[012])(:[0-5]\d) [APap][mM]$/.test(value)
        dateString = "#{@get('date').toDateFormat()} #{value}"
        @set 'date', Ember.DateTime.parse dateString, "%Y-%m-%d %i:%M %p"
    else if !value && @get('date')
      @get('date').toMeridianTime()
    else
      value
  ).property('date')

  willDestroyElement: ->
    @$('.timepicker').timepicker('remove')

  didInsertElement: ->
    element = @$('.timepicker')
    element.timepicker
      showDuration: true
      scrollDefaultNow: true
      selectOnBlur: true
      forceRoundTime: false
      timeFormat: 'h:i A'

    return unless @get('date')
    advance = @get('date').getRoundTime()

    @set('date', advance)
    element.timepicker('setTime', @get('date').toJSDate())

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'
    disabledBinding: 'parentView.disabled'
    valueBinding: 'parentView.text'
