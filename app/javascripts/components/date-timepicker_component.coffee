require 'lib/radium/date_picker'

Radium.DateTimepickerComponent = Ember.Component.extend
  actions:
    setSchedule: ->
      @set('isSubmitted', true)
      return if  @get('selectedDate')?.isBeforeNow()
      @sendAction 'submitDate', @get('model'), @get('selectedDate')

  selectedDate: null

  init: ->
    @_super.apply this, arguments
    @set 'isSubmitted', false
    @set 'selectedDate', Ember.DateTime.create().advance(day: 1)

  datePicker: Radium.DatePicker.extend
    classNames: ['time-picker']
    dateBinding: 'controller.selectedDate'
    leader: null
    isInvalid: (->
      return false unless @get('isSubmitted')
      return false if Ember.isEmpty(@get('text'))
      return false unless @get('controller.selectedDate')

      @get('date').isBeforeNow()
    ).property('isSubmitted', 'controller.selectedDate')

  time: Radium.TimePickerView.extend
    dateBinding: 'controller.selectedDate'
    isInvalid: ( ->
      return false unless @get('controller.isSubmitted')
      @get('date').isBeforeNow()
    ).property('controller.isSubmitted', 'controller.selectedDate')
