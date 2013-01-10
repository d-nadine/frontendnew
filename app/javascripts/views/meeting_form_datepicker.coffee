require 'radium/views/date_picker_field'

Radium.MeetingFormDatepicker = Radium.DatePickerField.extend
  elementId: "start-date"
  viewName: "meetingStartDate"
  name: "start-date"
  classNames: ["input-small"]

  minDate: (->
    new Date()
  ).property()

  defaultDate: Ember.DateTime.create()

  value: ( (key, value) ->
    if arguments.length is 1
      if value = @get("dateValue")
        value.toFormattedString "%Y-%m-%d"
    else
      currentDate = @get("dateValue")
      date = undefined
      if value
        date = Ember.DateTime.parse(value, "%Y-%m-%d")
      else
        date = @get("defaultDate")
      @set "dateValue", currentDate.adjust(
        day: date.get("day")
        month: date.get("month")
        year: date.get("year")
      )
      value
  ).property("dateValue")
