Radium.DealMainComponent = Ember.Component.extend Radium.ScrollableMixin,
  Radium.SaveEmailMixin,

  actions:
    deleteDeal: ->
      @sendAction "deleteDeal", @get('deal')

      false

    saveEmail: (email) ->
      @_super email, dontTransition: true

      return unless email.get('isValid')

      @flashMessenger.success 'Email Sent!'

      false

  formBox: Ember.computed 'todoForm', ->
    formBox = Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')
      about: @get('deal')

    formBox.emailForm = @get('emailForm')

    formBox

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'deal', 'tomorrow', ->
    reference: @get('deal')
    finishBy: null
    user: @get('currentUser')

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'deal', ->
    reference: @get('deal')
    user: @get('currentUser')

  emailForm: Radium.computed.newForm 'email'

  emailFormDefaults: Ember.computed 'contact', ->
    to: Ember.A([@get('contact')].compact())

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'contact', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('contact')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: Ember.DateTime.create()
    endsAt: Ember.DateTime.create().advance(hour: 1)
    invitations: Ember.A()

  loadedPages: [1]

  contact: Ember.computed 'deal', ->
    @get('deal.contact')
