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

  time: Radium.TimePickerView.extend
    dateBinding: 'controller.selectedDate'
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.selectedDate', ->
      return false unless @get('controller.isSubmitted')
      @get('date').isBeforeNow()
