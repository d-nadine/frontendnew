Radium.TimePicker = Ember.Mixin.create
  didInsertElement: ->
    start = @get('date')
    isoTime = start.toISO8601()
    now = new Date(isoTime)

    @$().timepicker(
      scrollDefaultNow: true
      minTime: start.toFormattedString('%i:%M%p')
      maxTime: '11:30pm'
    ).timepicker 'setTime', now

    @$().on 'changeTime', $.proxy(->
      timeValue = @get('value').toUpperCase()
      time = Ember.DateTime.parse(timeValue, '%i:%M%p')
      newHour = time.get('hour')
      newMin = time.get('minute')
      dateObj = @get('date')
      @set 'date', dateObj.adjust(
        hour: newHour
        minute: newMin
      )
    , this)

  willDestroyElement: ->
    @$().off 'changeTime'
