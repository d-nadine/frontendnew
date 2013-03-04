Radium.FormBoxController = Ember.ObjectController.extend
  activeForm: 'todo'

  showTodoForm: Radium.computed.equal('activeForm', 'todo')
  showCallForm: Radium.computed.equal('activeForm', 'call')
  showDiscussionForm: Radium.computed.equal('activeForm', 'discussion')
  showMeetingForm: Radium.computed.equal('activeForm', 'meeting')

  showForm: (form) ->
    @set 'activeForm', form
