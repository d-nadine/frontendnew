Radium.MeetingFormView = Radium.FormView.extend
  templateName: 'meeting_form'

  close: ->
    @get('controller').close()

  topicValue: null
  locationValue: null
  startsAtValue: null
  endsAtValue: null

  moveFeed: (->
    date = @get('controller.startsAtValue').toFormattedString '%Y-%m-%d'
    Radium.get('router').transitionTo 'root.dashboardWithDate', date: date, disableScroll: true
  ).observes('controller.startsAtValue')

  topicField: Ember.TextField.extend(Radium.Validate,
    elementId: 'description'
    placeholder: 'Meeting description'
    valueBinding: 'controller.topicValue'
    validate: ->
      @get 'value'
  )

  meetingStartDateField: Radium.MeetingFormDatepicker.extend(
    dateValueBinding: 'controller.startsAtValue'
    elementId: 'start-date'
    viewName: 'meetingStartDate'
    name: 'start-date'
  )

  meetingEndDateField: Radium.MeetingFormDatepicker.extend(
    dateValueBinding: 'controller.endsAtValue'
    elementId: 'end-date'
    viewName: 'meetingEndDate'
    name: 'end-date'
  )

  startsAtField: Ember.TextField.extend(Radium.TimePicker,
    classNames: ['time']
    dateBinding: 'controller.startsAtValue'
  )

  endsAtField: Ember.TextField.extend(Radium.TimePicker,
    classNames: ['time']
    dateBinding: 'controller.endsAtValue'
  )

  submitForm: ->
    # TODO: extract doStuff into global form shared functionality
    doStuff = ->
      @get('controller').createMeeting()

      @close()

    @$().slideUp('fast')
    self = this
    setTimeout (-> doStuff.apply(self) ), 200
