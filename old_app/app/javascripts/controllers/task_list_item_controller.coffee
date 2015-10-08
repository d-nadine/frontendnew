Radium.TaskListItemController = Radium.ObjectController.extend Radium.TaskMixin,
  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', ->
    description: null
    content: @get('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', ->
    topic: null
    location: ""
    content: @get('model')
    invitations: Ember.A()
