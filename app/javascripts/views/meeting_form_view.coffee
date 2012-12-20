Radium.MeetingFormView = Radium.FormView.extend
  templateName: 'radium/meeting_form'

  close: ->
    @get('controller').close()

  topicField: Ember.TextField.extend(Radium.Validate,
    elementId: 'description'
    placeholder: 'Meeting description'
    valueBinding: 'controller.topicValue'
    validate: ->
      @get 'value'
  )

  meetingStartDateField: Radium.MeetingFormDatepicker.extend(
    dateValueBinding: 'controller.startsAtDate'
    elementId: 'start-date'
    viewName: 'meetingStartDate'
    name: 'start-date'
  )

  meetingEndDateField: Radium.MeetingFormDatepicker.extend(
    dateValueBinding: 'controller.endsAtDate'
    elementId: 'end-date'
    viewName: 'meetingEndDate'
    name: 'end-date'
  )

  startsAtField: Ember.TextField.extend(Radium.TimePicker,
    classNames: ['time']
    dateBinding: 'controller.startsAt'
  )

  endsAtField: Ember.TextField.extend(Radium.TimePicker,
    classNames: ['time']
    dateBinding: 'controller.endsAt'
  )

  submitForm: ->
    doStuff = ->
      @get('controller').createMeeting()

    @close()

    @hide()
    self = this
    setTimeout (-> doStuff.apply(self) ), 200

  hide: ->
    @$().slideUp('fast')
