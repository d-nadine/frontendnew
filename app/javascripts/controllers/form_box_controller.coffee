Radium.FormBoxController = Radium.ObjectController.extend Ember.Evented,
  actions:
    showForm: (form) ->
      @get("#{form}Form").reset()
      @set 'activeForm', form
      if @get('showMeetingForm')
        @set 'meetingForm.isExpanded', true

      Ember.run.later this, =>
        @trigger 'focusTopic'
      , 400

    submitForm: ->
      activeForm = @get("#{@get('activeForm')}Form")
      activeForm.set('submitForm', true)
      @trigger 'focusTopic'

  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showDiscussionForm: Ember.computed.equal('activeForm', 'discussion')
  showNoteForm: Ember.computed.equal('activeForm', 'note')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')
