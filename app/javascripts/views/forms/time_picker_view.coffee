Radium.TimePickerView = Ember.View.extend
  templateName: 'forms/time_picker'
  classNames: ['input-append', 'bootstrap-timepicker']

  dateBinding: 'controller.startsAt'

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
    @set('date', Ember.DateTime.parse dateString, "%Y-%m-%d %i:%M %p")
    console.log @get('date').toDateFormat() + " " + @get('date').toMeridianTime()

  timeField: Ember.TextField.extend
    classNames: 'input-small timepicker'
