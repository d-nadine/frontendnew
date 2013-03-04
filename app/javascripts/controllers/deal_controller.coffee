Radium.DealController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')

  contact: Ember.computed.alias('model.contact')

  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  now: Ember.computed.alias('clock.now')

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
      discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: (->
    Radium.TodoForm.create
      content: Ember.Object.create
        reference: @get('model')
        finishBy: @get('tomorrow')
        user: @get('currentUser')
  ).property('model', 'tomorrow')

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
  ).property('model', 'tomorrow')
