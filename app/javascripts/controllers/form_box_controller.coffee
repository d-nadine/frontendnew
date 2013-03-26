Radium.FormBoxController = Ember.ObjectController.extend
  activeForm: 'todo'

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showDiscussionForm: Ember.computed.equal('activeForm', 'discussion')
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting')

  showForm: (form) ->
    @set 'activeForm', form
