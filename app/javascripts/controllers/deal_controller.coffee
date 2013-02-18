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
      isNew: true
      reference: @get('model')
      finishBy: @get('tomorrow')
      user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: (->
    Radium.CallForm.create
      isNew: true
      reference: @get('contact')
      finishBy: @get('tomorrow')
      user: @get('currentUser')
      canChangeContact: false
  ).property('model', 'tomorrow')

  discussionForm: (->
    Radium.DiscussionForm.create
      isNew: true
      reference: @get('model')
      user: @get('currentUser')
  ).property('model')
