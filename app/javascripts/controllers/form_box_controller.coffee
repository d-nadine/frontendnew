Radium.FormBoxController = Radium.ObjectController.extend
  actions:
    showForm: (form) ->
      @get("#{form}Form").reset()
      @set 'activeForm', form
      if @get('showMeetingForm')
        @set 'meetingForm.isExpanded', @get('showMeetingForm')

    submitForm: ->
      activeForm = @get("#{@get('activeForm')}Form")
      activeForm.set('submitForm', true)

  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showDiscussionForm: Ember.computed.equal('activeForm', 'discussion')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')
