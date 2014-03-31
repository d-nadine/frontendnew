Radium.CalendarView = Radium.View.extend Radium.DarkBackgroundMixin,
  Radium.ScrollTopMixin,
  classNames: ['page-view']
  didInsertElement: ->
    @_super.apply this, arguments
    date = new Date()
    dates = [date.getYear(), date.getMonth(), date.getDate()]
    @$('i.month-datepicker-button')
    .data('date', dates.join('-'))
    .datepicker(
      changeMonth: true
      dateFormat: "yy-mm-dd"
      numberOfMonths: [2, 3]
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

