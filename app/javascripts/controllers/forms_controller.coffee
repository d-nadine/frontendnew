Radium.FormsController = Ember.Controller.extend Radium.CurrentUserMixin,
  newTodo: (->
    Radium.TodoForm.create
      isNew: true
      user: @get('currentUser')
  ).property()

  editableTodo: (->
    Radium.TodoForm.create
      description: "Finish programming Radium"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: true
  ).property()

  editableFinishedTodo: (->
    Radium.TodoForm.create
      description: "Learn to make mistakes"
      isFinished: true
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: true
  ).property()

  uneditableTodo: (->
    Radium.TodoForm.create
      description: "Assign leads"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: false
  ).property()

  uneditableFinishedTodo: (->
    Radium.TodoForm.create
      isFinished: true
      description: "Conquer the world"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: false
  ).property()

  justAddedTodo: (->
    Radium.TodoForm.create
      description: "Assign leads"
      user: @get('currentUser')
      reference: Factory.create('contact')
      justAdded: true
  ).property()

  newCall: (->
    Radium.CallForm.create
      isNew: true
      user: @get('currentUser')
  ).property()

  editableCall: (->
    Radium.CallForm.create
      description: "Q4 sales"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: true
  ).property()

  editableFinishedCall: (->
    Radium.CallForm.create
      isEditable: true
      isFinished: true
      description: "Q4 sales"
      user: @get('currentUser')
      reference: Factory.create('contact')
  ).property()

  uneditableCall: (->
    Radium.CallForm.create
      description: "Our trade secrets"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: false
  ).property()

  uneditableFinishedCall: (->
    Radium.CallForm.create
      isFinished: true
      description: "q3 strategy"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: false
  ).property()

  justAddedCall: (->
    Radium.CallForm.create
      isFinished: false
      description: "Secret sauce"
      user: @get('currentUser')
      reference: Factory.create('contact')
      isEditable: true
      justAdded: true
  ).property()

  source: (->
    Ember.A([
      Ember.Object.create(name: "Adam")
      Ember.Object.create(name: "Paul")
      Ember.Object.create(name: "Sami")
      Ember.Object.create(name: "Riikka")
    ])
  ).property()

  discussion: (->
    Radium.DiscussionForm.create
      user: @get('currentUser')
      isNew: true
  ).property()

  justAddedDiscussion: (->
    Radium.DiscussionForm.create
      user: @get('currentUser')
      text: "Big long text from the discussion"
      justAdded: true
  ).property()

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('newTodo')
      callForm: @get('newCall')
      discussionForm: @get('discussion')
  ).property()
