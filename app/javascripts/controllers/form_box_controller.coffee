Radium.FormBoxController = Radium.ObjectController.extend
  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showDiscussionForm: Ember.computed.equal('activeForm', 'discussion')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')

  showMeetingFormChanges: ( ->
    @set 'meetingForm.isExpanded', @get('showMeetingForm')
  ).observes('showMeetingForm')

  showForm: (form) ->
    @set 'activeForm', form

  submitForm: ->
    @get("#{@get('activeForm')}Form").set('submitForm', true)
