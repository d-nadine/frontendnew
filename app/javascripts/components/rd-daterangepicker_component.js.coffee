Radium.RdDaterangepickerComponent = Ember.Component.extend
  startDate: new Date()
  endDate: new Date()
  past: true
  future: false

  ranges: Ember.computed "past", "future", ->
    standardRange =
      '+/- 1 year': [moment().subtract('years', 1), moment().add('years', 1)]
      'Today': [moment(), moment()]
    pastRange =
      'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)]
      'Last 7 Days': [moment().subtract('days', 6), moment()]
      'Last 30 Days': [moment().subtract('days', 29), moment()]
      'This Month': [moment().startOf('month'), moment().endOf('month')]
      'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
    futureRange =
      'Tomorrow': [moment().add('days', 1), moment().add('days', 1)]
      'Next 7 Days': [moment(), moment().add('days', 6)]
      'Next 30 Days': [moment(), moment().add('days', 29)]
      'This Month': [moment().startOf('month'), moment().endOf('month')]
      'Next Month': [moment().add('month', 1).startOf('month'), moment().add('month', 1).endOf('month')]
    if @get("past")
      Ember.merge standardRange, pastRange
    if @get("future")
      Ember.merge standardRange, futureRange

    return standardRange

  syncField: Ember.observer("startDate", "endDate", ->
    @picker.setStartDate @get("startDate")
    @picker.setEndDate @get("endDate")
    @picker.container.find('button.applyBtn').click()
  ).on('didInsertElement')

  initializeDaterangepicker: (->
    @picker = @$('input.daterange-field').daterangepicker
      startDate: @get("startDate")
      endDate: @get("endDate")
      opens: 'left'
      ranges:
        @get("ranges")
      (start, end) =>
        @set("startDate", moment(start).toDate())
        @set("endDate", moment(end).toDate())
    .data('daterangepicker')
  ).on("didInsertElement")