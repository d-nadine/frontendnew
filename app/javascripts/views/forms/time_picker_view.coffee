Radium.TimePickerView = Ember.View.extend
  templateName: 'forms/time_picker'
  classNameBindings: [
    'date:is-valid'
    'disabled:is-disabled'
    'isInvalid'
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':bootstrap-timepicker'
    ':input-append'
  ]

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  leader: 'Starts at:'
  dateBinding: 'controller.startsAt'

  disabled: Ember.computed.alias('controller.isDisabled')

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
    element.on 'changeTime', @setDate.bind(this)

  setDate:  ->
    time = @$('.timepicker').val()

    unless time.match(/^(0?[1-9]|1[012])(:[0-5]\d) [APap][mM]$/)
      @$('.timepicker').val(@get('date').toMeridianTime())
      return

    dateString = "#{@get('date').toDateFormat()} #{time}"
    date = Ember.DateTime.parse dateString, "%Y-%m-%d %i:%M %p"
    Ember.run =>
      @set('date', date) if date

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'
    disabledBinding: 'parentView.disabled'

  showTimes: ->
    if @get('showWidget')
      @$('.timepicker').timepicker('showWidget')
    else
      @$('.timepicker').timepicker('hideWidget')

    @toggleProperty 'showWidget'
    false
