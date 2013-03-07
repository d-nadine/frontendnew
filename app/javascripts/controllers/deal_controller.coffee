require 'forms/todo_form'

Radium.DealController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  now: Ember.computed.alias('clock.now')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    isNew: true
  ).property('model', 'tomorrow')

  todoForm: Radium.computed.newForm('todo')

  callForm: (->
    Radium.CallForm.create
      canChangeContact: false
      content: Ember.Object.create
        reference: @get('contact')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

  discussionForm: (->
    Radium.DiscussionForm.create
      content: Ember.Object.create
        reference: @get('model')
        user: @get('currentUser')
  ).property('model')

  meetingForm: ( ->
    Radium.MeetingForm.create
      content: Ember.Object.create
        isNew: true
        users: Em.ArrayProxy.create(content: [])
        contacts: Em.ArrayProxy.create(content: [])
        user: @get('currentUser')
        startsAt: @get('now')
        endsAt: @get('now').advance(hour: 1)
  ).property('now')
