Radium.DealController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')

  contact: Ember.computed.alias('model.contact')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
  ).property('model')

  todoForm: (->
    Radium.TodoForm.create
      content: Radium.Todo.createRecord
        reference: @get('model')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: (->
    Radium.CallForm.create
      canChangeContact: false
      content: Radium.Todo.createRecord
        kind: 'call'
        reference: @get('contact')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

  discussionForm: (->
    Radium.DiscussionForm.create
      content: Radium.Discussion.createRecord
        reference: @get('model')
        user: @get('currentUser')
  ).property('model')

  tasks: (->
    Radium.Todo.all()
  ).property()
