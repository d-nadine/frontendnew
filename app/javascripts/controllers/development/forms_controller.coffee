Radium.DevelopmentFormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  source: (->
    Ember.A([
      Ember.Object.create(name: "Adam")
      Ember.Object.create(name: "Paul")
      Ember.Object.create(name: "Sami")
      Ember.Object.create(name: "Riikka")
    ])
  ).property()


  # formBox: (->
  #   Radium.FormBox.create
  #     todoForm: @get('newTodo')
  #     callForm: @get('newCall')
  #     discussionForm: @get('discussion')
  #     meetingForm: @get('newMeeting')
  # ).property()
