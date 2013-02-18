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

  leader: 'Starts at:'
  dateBinding: 'controller.startsAt'

  isValid: ( ->
    true
  ).property()

  didInsertElement: ->
    element = @$('.timepicker')
    element.timepicker(defaultTime: @get('date').toMeridianTime())
    element.on 'changeTime.timepicker', (e) =>
      @setDate e.time.value

  dateDidChange: ( ->
    @setDate $('.timepicker').timepicker().val()
  ).observes('date')

  setDate: (time) ->
    dateString = "#{@get('date').toDateFormat()} #{time}"
    date = Ember.DateTime.parse dateString, "%Y-%m-%d %i:%M %p"
    @set('date', date) if date

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'

  showTimes: ->
    @$('.timepicker').timepicker('showWidget')


