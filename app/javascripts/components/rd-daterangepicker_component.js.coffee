Radium.RdDaterangepickerComponent = Ember.Component.extend
  startDate: new Date()
  endDate: new Date()
  past: true
  future: false
  placeholderText: "Select Date Range"

  keyPress: (event) ->
    if event.keyCode == 13
      event.preventDefault()
      @set "startDate", moment(@picker.startDate).toDate()
      @set "endDate", moment(@picker.endDate).toDate()

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

  syncField: ->
    Ember.run.once =>
      @picker.setStartDate @get("startDate") || moment().startOf('month')
      @picker.setEndDate @get("endDate") || moment().endOf('month')
      @picker.container.find('button.applyBtn').click()

  # Don't show the UNBOUND dummy values that get inserted on init
  clearOutField: Ember.observer "startDate", "endDate", ->
    Ember.run.later =>
      return unless @$("input")
      unless @get('startDate') and @get('endDate')
        @$("input").val("")

  initializeDaterangepicker: (->
    hasDateRange = @get('startDate') and @get('endDate')
    @set 'hasDateRangeWasEmptyOnInit', !hasDateRange
    @picker = @$('input.daterange-field').daterangepicker
      startDate: @get("startDate") || moment().startOf('month')
      endDate: @get("endDate") || moment().endOf('month').add('month', 1)
      format: "MM/DD/YYYY"
      opens: 'left'
      ranges:
        @get("ranges")
      (start, end) =>
        # for text input, use stricter validation rules
        if start._i and end._i
          start = moment(start._i, "MM/DD/YYYY", true)
          end = moment(end._i, "MM/DD/YYYY", true)

        if start.isValid() and end.isValid()
          @set("startDate", moment(start).toDate())
          @set("endDate", moment(end).toDate())
    .data('daterangepicker')
    @addObserver("startDate", this, "syncField")
    @addObserver("endDate", this, "syncField")
  ).on("didInsertElement")
