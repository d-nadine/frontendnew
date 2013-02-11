require 'lib/radium/show_more_mixin'

Radium.CalendarDayItemController = Ember.ArrayController.extend Radium.ShowMoreMixin,
  sortProperties: ['time']

  isDifferentMonth: (->
    @get('content.date.month') != @get('content.calendarDate.month')
  ).property('date')

  isToday: Radium.computed.isToday('content.date')

  day: (->
    @get('content.date.day')
  ).property('date')
