Radium.DatePicker = Radium.View.extend
  templateName: 'forms/date_picker'
  classNameBindings: [
    'date:is-valid'
    'disabled:is-disabled'
    'isInvalid'
    ':control-box'
    ':datepicker-control-box'
  ]

  leader: 'Due'

  dateBinding: 'controller.finishBy'
  textBinding: 'textToDateTransform'
  disabled: Ember.computed.alias('controller.isDisabled')

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: (->
    Ember.isEmpty(@get('text')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  textToDateTransform: ((key, value) ->
    if arguments.length == 2
      if value && /\d{4}-\d{2}-\d{2}/.test(value)
        @set 'date', Ember.DateTime.parse(value, '%Y-%m-%d')
      else if value && /^([a-z]+), ([a-z]+) (\d{1,2}) (\d{4})$/i.test(value)
        @set 'date', Ember.DateTime.parse(value, "%A, %B %D %Y")
      else if value && value.toLowerCase() == 'tomorrow'
        @set 'date', Ember.DateTime.create().advance(day: 1)
      else if value && value.toLowerCase() == 'today'
        @set 'date', Ember.DateTime.create()
      else
        @set 'date', null
    else if !value && @get('date')
      @get('date').toHumanFormat()
    else
      value
  ).property()

  defaultDate: (->
    Ember.DateTime.create().toDateFormat()
  ).property()

  didInsertElement: ->
    return if @$('.datepicker-link').length is 0

    @$('.datepicker-link').datepicker()
    @$('.btn.dropdown-toggle').dropdown()

    view = this

    @$('.datepicker-link').data('datepicker').place = ->
      mainButton = view.$('.btn.dropdown-toggle')

      offset = mainButton.offset()

      @picker.css
        top: offset.top + @height,
        left: offset.left

      event.preventDefault()

    @$('.datepicker-link').data('datepicker').set = ->
      target = $(event.target)
      return if target.hasClass('next') || target.hasClass('prev')

      view.set 'text', Ember.DateTime.create(@date.getTime()).toHumanFormat()

      @hide()

  setDate: (key) ->
    date = switch key
      when 'today'
        Ember.DateTime.create().atEndOfDay()
      when 'tomorrow'
        Ember.DateTime.create().advance(day: 1)
      when 'this_week'
        Ember.DateTime.create().atEndOfWeek()
      when 'next_week'
        Ember.DateTime.create().advance(day: 7)
      when 'next_month'
        Ember.DateTime.create().advance(month: 1)

    @set 'text', date.toHumanFormat()

  humanTextField: Ember.TextField.extend
    valueBinding: 'parentView.text'
    disabledBinding: 'parentView.disabled'
