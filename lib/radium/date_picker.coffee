Radium.DatePicker = Ember.View.extend
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
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  textToDateTransform: ((key, value) ->
    if arguments.length == 2
      if value && /\d{4}-\d{2}-\d{2}/.test(value)
        @set 'date', Ember.DateTime.parse(value, '%Y-%m-%d')
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

    view = this

    @$('.datepicker-link').data('datepicker').place = ->
      mainButton = view.$('.btn.dropdown-toggle')

      offset = mainButton.offset()

      @picker.css
        top: offset.top + @height,
        left: offset.left

    @$('.datepicker-link').data('datepicker').set = ->
      view.set 'text', Ember.DateTime.create(@date.getTime()).toDateFormat()
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
