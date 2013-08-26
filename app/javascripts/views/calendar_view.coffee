Radium.CalendarView = Radium.View.extend Radium.DarkBackgroundMixin,
  classNames: ['page-view']
  didInsertElement: ->
    @$('i.month-datepicker-button').datepicker(
      changeMonth: true
      dateFormat: "yy-mm-dd"
      numberOfMonths: [2, 3]
      defaultDate: new Date()
    )
    .on('changeDate', (event) =>
      date = Ember.DateTime.create
        day: event.date.getDate()
        month: event.date.getMonth()
        year: event.date.getYear()

      @get('controller').send 'selectDay', date
    )
    .on('click', =>
      $().datepicker('show')
    )

