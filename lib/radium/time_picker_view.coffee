Radium.TimePickerView = Ember.View.extend
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

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  leader: 'Starts at:'

  disabled: Ember.computed.alias('controller.isDisabled')

  textBinding: 'textToTimeTransform'

  showTimePicker: ->
    return if @get('disabled')
    @$('.timepicker').trigger('click.timepicker')

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
      forceRoundTime: true
      timeFormat: 'h:i A'

    minutes = parseInt(@get('date').toFormattedString('%M'), 10)

    roundUp = if minutes > 30
                60 - minutes
              else
                30 - minutes

    element.timepicker('setTime', @get('date').advance(minute: roundUp).toJSDate())

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'
    disabledBinding: 'parentView.disabled'
    valueBinding: 'parentView.text'
