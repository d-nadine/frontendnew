Radium.RdDaterangepickerComponent = Ember.Component.extend
  startDate: new Date()
  endDate: new Date()

  initializeDaterangepicker: (->
    @$('input.daterange-field').daterangepicker
      startDate: @get("startDate")
      endDate: @get("endDate")
      opens: 'left'
      ranges:
        'Today': [moment(), moment()]
        'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)]
        'Last 7 Days': [moment().subtract('days', 6), moment()]
        'Last 30 Days': [moment().subtract('days', 29), moment()]
        'This Month': [moment().startOf('month'), moment().endOf('month')]
        'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
      (start, end) =>
        @set("startDate", moment(start).toDate())
        @set("endDate", moment(end).toDate())
  ).on("didInsertElement")
