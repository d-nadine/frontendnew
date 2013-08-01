require 'lib/radium/show_more_mixin'

Radium.CalendarDayItemController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['calendarIndex', 'calendarSidebar']
  calendarDate: Ember.computed.alias('controllers.calendarIndex.date')

  selectedTask: Ember.computed.alias 'controllers.calendarSidebar.selectedTask'
  selectedDay: Ember.computed.alias 'controllers.calendarSidebar.selectedDay'

  sortProperties: ['time']

  isDifferentMonth: (->
    @get('content.date.month') != @get('calendarDate.month')
  ).property('date')

  isToday: Radium.computed.isToday('content.date')

  isSelectedDate: ( ->
    selectedDay = @get('selectedDay')
    isToday = @get('isToday')

    return true if !selectedDay && isToday

    selectedDay == @get('model')
  ).property('isToday', 'selectedDay')

  day: (->
    @get('content.date.day')
  ).property('date')

  selectCalendarTask: (task) ->
    @set 'controllers.calendarSidebar.selectedTask', task
