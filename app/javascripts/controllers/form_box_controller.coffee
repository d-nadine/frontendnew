Radium.FormBoxController = Ember.ObjectController.extend
  activeForm: 'todo'

  showTodoForm: Radium.computed.equal('activeForm', 'todo')
  showCallForm: Radium.computed.equal('activeForm', 'call')
  showDiscussionForm: Radium.computed.equal('activeForm', 'discussion')

  showForm: (form) ->
    @set 'activeForm', form
