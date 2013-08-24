Radium.CalendarView = Radium.View.extend Radium.DarkBackgroundMixin,
  classNames: ['page-view']
  didInsertElement: ->
    @$('i.month-datepicker-button').datepicker(
      changeMonth: true
      dateFormat: "yy-mm-dd"
      numberOfMonths: [2, 3]
      defaultDate: new Date()
      onSelect: (date, datepicker) =>
        date = Ember.DateTime.parse(date, '%Y-%m-%d')
        @set 'controller.date', date
    ).on 'click', =>
      $().datepicker('show')

