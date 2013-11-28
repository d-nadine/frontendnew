Radium.FormBoxController = Radium.ObjectController.extend
  actions:
    showForm: (form) ->
      @get("#{form}Form").reset()
      @set 'activeForm', form

    submitForm: ->
      activeForm = @get("#{@get('activeForm')}Form")
      activeForm.set('submitForm', true)

  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showDiscussionForm: Ember.computed.equal('activeForm', 'discussion')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')

  showMeetingFormChanges: ( ->
    return unless @get('meetingForm')
    @set 'meetingForm.isExpanded', @get('showMeetingForm')
  ).observes('showMeetingForm')
