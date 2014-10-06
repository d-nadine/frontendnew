require 'lib/radium/show_more_mixin'

Radium.CalendarDayItemController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  actions:
    selectCalendarTask: (task) ->
      @set 'controllers.calendarIndex.selectedTask', task
      @transitionToRoute "calendar.task", task

  needs: ['calendarIndex', 'calendarSidebar']
  calendarDate: Ember.computed.alias('controllers.calendarIndex.date')

  selectedTask: Ember.computed.alias 'controllers.calendarIndex.selectedTask'
  selectedDay: Ember.computed.alias 'controllers.calendarIndex.selectedDay'

  sortProperties: ['time']

  isDifferentMonth: Ember.computed 'date', ->
    @get('content.date.month') != @get('calendarDate.month')

  isToday: Radium.computed.isToday('content.date')

  isSelectedDate: Ember.computed 'isToday', 'selectedDay', ->
    selectedDay = @get('selectedDay')
    isToday = @get('isToday')

    return true if !selectedDay && isToday

    selectedDay && (selectedDay.get('date').isTheSameDayAs(@get('model.date')))

  day: Ember.computed 'date', ->
    @get('content.date.day')
  