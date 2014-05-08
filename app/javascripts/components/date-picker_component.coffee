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

  disabled: Ember.computed.alias('targetObject.isDisabled')
  isSubmitted: Ember.computed.alias('targetObject.isSubmitted')

  isInvalid: Ember.computed 'date', 'isSubmitted', ->
    return false unless @get('isSubmitted')
    return false if Ember.isEmpty(@get('text'))
    return false unless @get('date')

    @get('date').isBeforeToday()

  textToDateTransform: Ember.computed 'date', (key, value) ->
    if arguments.length == 2
      return
    else if !value && @get('date')
      @get('date').toHumanFormat()
    else
      value

  humanTextField: Ember.TextField.extend
    viewName: 'dateDisplay'
    TAB: 9
    ENTER: 13
    ESCAPE: 27
    valueBinding: 'parentView.text'
    disabledBinding: 'targetObject.disabled'
    date: Ember.computed.alias 'targetObject.date'

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
      milliseconds = evt.date.add(new Date().getHours() + 1).hours().valueOf()
      @set 'date', Ember.DateTime.create(milliseconds)
      @$().data('datepicker').hide()
      target = @get('targetObject')

      return if evt.dontSubmit
      return unless target.get('submitForm')

      target.sendAction 'submitForm'

    hideDatePicker: ->
      return if @isDestroyed
      @set('pickerShown', true)

    showDatePicker: ->
      return if @isDestroyed

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
      else if keyCode == @ESCAPE
        @resetDateDisplay()
      else if keyCode = @TAB
        @$().trigger
          type: 'changeDate'
          date: date
          dontSubmit: true

        @$('.datepicker').find('a').attr('tabindex','-1')
        @$().parent().next().find('input').focus()

      evt.stopPropagation()
      evt.preventDefault()

    resetDateDisplay: ->
      originalDate = if @get('date') then @get('date').toJSDate() else Date.today()

      @$().data('datepicker').hide()

    valueDidChange: ->
      originalDate = @get('date')?.toJSDate()
      return unless originalDate
      today = Ember.DateTime.create().toJSDate()
      value = @get('value')?.toLowerCase()
      datePicker = @get('datePicker')

      days =
        "sat": "saturday"
        "sun": "sunday"
        "mon": "monday"
        "tue": "tuesday"
        "wed": "wednesday"
        "thu": "thursday"
        "fri": "friday"

      if value?.length <= 2
        @$().datepicker('setValue', originalDate)
        return

      parsed = Date.parse value

      for k, v of days
        if value?.indexOf(k) != -1
          parsed = Date.parse v
          isDayOfWeek = true
          break

      if value == 'next'
        parsed = Date.today()

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

      if /^\btom(?:o(?:r(?:r(?:ow?)?)?)?)?\b$/i.test(value)
        parsed = Date.parse('tomorrow')

      if /^\btod(?:ay?)?\b$/i.test(value)
        parsed = Date.today()

      result = new Date(parsed)

      if (result.toString() == "Invalid Date") || result.getTime() == 0
        @$().datepicker('setValue', originalDate)
        return

      @$().datepicker('setValue', result)

    focusIn: (e) ->
      Ember.run.next  =>
        @$().get(0).select()
