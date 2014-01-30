Radium.DatePickerComponent = Ember.Component.extend
  actions:
    showPicker: ->
      view = @get('dateDisplay')

      datePicker = @get('datePicker')

      unless @get('pickerShown')
        datePicker.show()

        Ember.run.next  =>
          view.$().get(0).select()
      else
        datePicker.hide()

      @toggleProperty 'pickerShown'

      false

  pickerShown: false

  classNameBindings: [
    'date:is-valid'
    'disabled:is-disabled'
    'isInvalid'
    ':control-box'
    ':datepicker-control-box'
  ]

  leader: 'Due'

  textBinding: 'textToDateTransform'
#   disabled: Ember.computed.alias('controller.isDisabled')
# 
#   isSubmitted: Ember.computed.alias('controller.isSubmitted')
#   isInvalid: (->
#     Ember.isEmpty(@get('text')) && @get('isSubmitted')
#   ).property('value', 'isSubmitted')
# 
  humanTextField: Ember.TextField.extend
    viewName: 'dateDisplay'
    TAB: 9
    ENTER: 13
    ESCAPE: 27
    valueBinding: 'parentView.text'
    # disabledBinding: 'parentView.disabled'
    init: ->
      @_super.apply(this, arguments)

      allowedKeyCodes = Ember.A([@TAB, @ENTER, @ESCAPE])
      @set('allowedKeyCodes', allowedKeyCodes)

    didInsertElement: ->
      @_super.apply this, arguments
      @addObserver 'value', this, 'valueDidChange'
      nowTemp = new Date()
      now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)

      input = @$().datepicker
        onRender: (date) ->
          if date.valueOf() < now.valueOf() then 'disabled' else ''

      datePicker = input.data('datepicker')

      @$().off('keyup', datePicker.update)

      @set('targetObject.datePicker', datePicker)

      input.on 'show', @showDatePicker.bind(this)
      input.on 'hide', @hideDatePicker.bind(this)
      input.on 'changeDate', @changeDatePicker.bind(this)

    changeDatePicker: (evt) ->
      @get('targetObject').set 'date', Ember.DateTime.create(evt.date.valueOf())
      @$().data('datepicker').hide()

    hideDatePicker: ->
      @set('pickerShown', true)

    showDatePicker: ->
      @set('pickerShown', false)

    willDestroyElement: ->
      @_super.apply this, arguments
      @removeObserver 'value', this, 'valueDidChange'
      datePicker = @$().datepicker()
      datePicker.off 'show', @showDatePicker
      datePicker.off 'hide', @hideDatePicker
      datePicker.off 'changeDate', @changeDatePicker

    keyDown: (evt) ->
      datepicker = @$().data('datepicker')

      unless @$('.datepicker.dropdown-menu').is(':visible')
        datepicker.show()

      keyCode = evt.keyCode

      return unless @get('allowedKeyCodes').contains keyCode

      date = datepicker.date
      if keyCode == @ENTER
        @$().trigger
          type: 'changeDate'
          date: date

      evt.stopPropagation()
      evt.preventDefault()

    valueDidChange: ->
      originalDate = @get('date')
      today = Ember.DateTime.create().toJSDate()
      value = @get('value')?.toLowerCase()
      datePicker = @get('datePicker')

      days =
        "sun": "sunday"
        "mon": "monday"
        "tue": "tuesday"
        "wed": "wednesday"
        "thu": "thursday"
        "fri": "friday"

      if value?.length > 2
        parsed = Date.parse value

      if day = days[value]
        parsed = Date.parse day
        isDayOfWeek = true

      if value == 'next'
        parsed = Date.today()

      if /^\btom(?:o(?:r(?:r(?:ow?)?)?)?)?\b$/i.test(value)
        parsed = Date.parse('tomorrow')

      if parsed && parsed.isBefore(today)
        if isDayOfWeek
          parsed.add(days: 7)
        else
          parsed.add(years: 1)

      if (parsed && value.indexOf("next") != -1) && parsed.isAfter(today)
        if Date.equals(parsed,Date.today().addDays(7))
          parsed = parsed.add(days: 0)
        else
          parsed.add(days: 7)

      result = new Date(parsed)

      return if result.toString() == "Invalid Date"

      @$().datepicker('setValue', result)

    focusIn: (e) ->
      Ember.run.next  =>
        @$().get(0).select()

  defaultDate: (->
    Ember.DateTime.create().toDateFormat()
  ).property()

  textToDateTransform: ((key, value) ->
    if arguments.length == 2
      return 
    else if !value && @get('date')
      @get('date').toHumanFormat()
    else
      value
  ).property('date')
