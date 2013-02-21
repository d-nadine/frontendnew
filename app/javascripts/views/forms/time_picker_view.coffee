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

  didInsertElement: ->
    element = @$('.timepicker')
    element.timepicker(defaultTime: @get('date').toMeridianTime())
    element.on 'changeTime.timepicker', (e) =>
      @setDate e.time.value

  setDate: (time) ->
    dateString = "#{@get('date').toDateFormat()} #{time}"
    date = Ember.DateTime.parse dateString, "%Y-%m-%d %i:%M %p"
    Ember.run =>
      @set('date', date) if date

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'

  showWidget: true
  showTimes: ->
    if @get('showWidget')
      @$('.timepicker').timepicker('showWidget')
    else
      @$('.timepicker').timepicker('hideWidget')

    @toggleProperty 'showWidget'
    false
