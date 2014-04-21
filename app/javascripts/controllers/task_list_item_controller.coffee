Radium.TaskListItemController = Radium.ObjectController.extend Radium.TaskMixin,
  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    content: @get('model')
  ).property('model')

  callForm: Radium.computed.newForm('call')

  callFormDefaults: (->
    description: null
    reference: @get('model')
  ).property('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    location: ""
    content: @get('model')
    invitations: Ember.A()
  ).property('model')
