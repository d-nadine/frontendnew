require "mixins/save_contact_actions"
require "mixins/save_contact_actions"
require "mixins/controllers/track_contact_mixin"

Radium.ContactMainComponent = Ember.Component.extend Radium.TrackContactMixin,
  Radium.SaveContactActions,
  Radium.SaveEmailMixin,
  Radium.ScrollableMixin,
  Ember.Evented,
  actions:
    deleteContact: ->
      @sendAction "deleteContact", @get('contact')

      false

    removeMultiple: (relationship, item) ->
      @get(relationship).removeObject item

    saveEmail: (email) ->
      @_super email, dontTransition: true

      return unless email.get('isValid')

      @flashMessenger.success 'Email Sent!'

      false

    deleteTask: (task) ->
      task.delete().then =>
        @flashMessenger.success 'task deleted!'

  # UPGRADE: replace with inject
  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')

  companies: Ember.computed ->
    @container.lookup('controller:companies')

  users: Ember.computed ->
    @container.lookup('controller:users')

  leadSources: Ember.computed ->
    @container.lookup('controller:accountSettings').get('leadSources')

  customFields: Ember.A()

  loadedPages: [1]

  model: Ember.computed.oneWay 'contact'

  formBox: Ember.computed 'todoForm', 'contact.email', ->
    formBox = Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')
      about: @get('contact')

    formBox.emailForm = @get('emailForm')

    formBox

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'contact', 'tomorrow', ->
    reference: @get('contact')
    finishBy: null
    user: @get('currentUser')

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

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'contact', ->
    reference: @get('contact')
    user: @get('currentUser')

  emailForm: Radium.computed.newForm 'email'

  emailFormDefaults: Ember.computed 'contact', ->
    to: Ember.A([@get('contact')].compact())

  queryParams: ['form']
  form: null
