Radium.DatePickerComponent = Ember.Component.extend
  actions:
    showPicker: ->
      view = @get('dateDisplay')

      datePicker = @get('datePicker')

      pickerShown = $('.datepicker-days').is(':visible')

      Ember.run.next ->
        unless pickerShown
          datePicker.show()

          Ember.run.next  ->
            view.$().get(0)?.select()
        else
          datePicker.hide()

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
  ignoreEmpty: false

  isInvalid: Ember.computed 'date', 'isSubmitted', ->
    return false unless @get('isSubmitted')
    return true if Ember.isEmpty(@get('text')) && !@get('ignoreEmpty')
    return !@get('ignoreEmpty') unless @get('date')

    @get('date').isBeforeToday()

  textToDateTransform: Ember.computed 'date', (key, value) ->
    if arguments.length == 2
      return
    else if !value && @get('date')
      @get('date').toHumanFormat()
    else
      value

  humanTextField: Ember.TextField.extend Radium.KeyConstantsMixin,
    viewName: 'dateDisplay'
    valueBinding: 'parentView.text'
    disabledBinding: 'targetObject.disabled'
    date: Ember.computed.alias 'targetObject.date'
    classNameBindings: [":date-picker"]
    placeholder: Ember.computed.alias 'targetObject.placeholder'

    init: ->
      @_super.apply(this, arguments)

      allowedKeyCodes = Ember.A([@TAB, @ENTER, @ESCAPE, @DELETE])
      @set('allowedKeyCodes', allowedKeyCodes)

    setup: Ember.on 'didInsertElement', ->
      @_super.apply this, arguments
      @addObserver 'value', this, 'valueDidChange'
      nowTemp = new Date()
      now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)

      input = @$().datepicker
        onRender: (date) ->
          if date.valueOf() < now.valueOf() then 'disabled' else ''

      datePicker = input.data('datepicker')

      modelDate = @get('date')

      defaultViewDate = if modelDate && !modelDate.isBeforeToday()
                          modelDate.toJSDate()
                        else
                          Date.parse('tomorrow')

      formatNumber = (number) ->
        ("0" + number).slice(-2)

      formatted = "#{formatNumber(defaultViewDate.getMonth() + 1)}/#{formatNumber(defaultViewDate.getDate())}/#{defaultViewDate.getFullYear()}"
      @$().datepicker('update', formatted);

      $(".scroll-pane").scroll =>
        @$().datepicker "place" if @$()

      @$().off('keyup', datePicker.update)

      @set('targetObject.datePicker', datePicker)

      input.on 'show', @showDatePicker.bind(this)
      input.on 'hide', @hideDatePicker.bind(this)
      input.on 'changeDate', @changeDatePicker.bind(this)

    changeDatePicker: (evt) ->
      return unless el = @$()
      milliseconds = evt.date.add(new Date().getHours() + 1).hours().valueOf()
      @set 'date', Ember.DateTime.create(milliseconds)
      el.data('datepicker').hide()
      target = @get('targetObject')

      return if evt.dontSubmit
      return unless target.get('submitForm')

      Ember.run.next =>
        target.sendAction 'submitForm', @get('date')

    hideDatePicker: ->
      return if @isDestroyed

    showDatePicker: ->
      return if @isDestroyed


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

      clearDate = =>
        targetObject = @get('targetObject')
        targetObject.set 'date', null
        @$().datepicker('setValue', null)
        datepicker = @$().data('datepicker')
        datepicker.hide()
        datepicker.viewDate = datepicker.date = new Date()

        Ember.run.next ->
          targetObject.sendAction("dateCleared")

      changeDate = =>
        @$().trigger
          type: 'changeDate'
          date: date

      date = datepicker.date

      if keyCode == @ENTER
        Ember.run.next =>
          unless @$().val()
            clearDate()
            return @get('targetObject').sendAction('submitForm')
          else
            changeDate()
      else if keyCode == @ESCAPE
        @resetDateDisplay()
      else if keyCode == @TAB
        @$().data('datepicker').hide()

        @$('.datepicker').find('a').attr('tabindex','-1')
        this.$().parent().next().children('input:first').get(0)?.focus()
      else if keyCode == @DELETE
        Ember.run.next =>
          unless @$().val()
            clearDate()

        return

      evt.stopPropagation()
      evt.preventDefault()

    resetDateDisplay: ->
      originalDate = if @get('date') then @get('date').toJSDate()

      if originalDate
        @$().datepicker('setValue', originalDate)
        @set('value', @get('date').toHumanFormat())
      else
        @set('value', '')

      @$().data('datepicker').hide()

    valueDidChange: ->
      originalDate = @get('date')?.toJSDate()

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

      if !value || originalDate?.isMinDate()
        @set('value', null)
        return

      if value?.length <= 2 && originalDate
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

      if ((result.toString() == "Invalid Date") || result.getTime() == 0) && originalDate
        @$().datepicker('setValue', originalDate)
        return

      @$().datepicker('setValue', result) unless result.isMinDate()

    focusIn: (e) ->
      Ember.run.next  =>
        ele = @$()

        return unless ele && ele?.get(0)

        @$().get(0).select()
