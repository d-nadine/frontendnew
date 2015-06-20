require "mixins/save_contact_actions"
require "mixins/persist_tags_mixin"

Radium.ContactController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.UpdateContactPoller,
  Radium.CanFollowMixin,
  Radium.TrackContactMixin,
  Radium.SaveContactActions,
  Radium.PersistTagsMixin,
  Ember.Evented,
  actions:
    removeMultiple: (relationship, item) ->
      @get(relationship).removeObject item

  needs: ['users', 'contacts', 'companies', 'countries', 'accountSettings', 'contactStatuses']

  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  companies: Ember.computed.oneWay 'controllers.companies'
  contact: Ember.computed.alias 'model'
  users: Ember.computed.oneWay 'controllers.users'

  customFields: Ember.A()

  # FIXME: How do we determine this?
  isEditable: true
  loadedPages: [1]

  dealsTotal: Ember.computed 'deals.[]', ->
    @get('deals').reduce((preVal, item) ->
      value = if item.get('status') == 'closed' then item.get('value') else 0

      preVal + value
    , 0, 'value')

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')
      emailForm: @get('emailForm')
      about: @get('model')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'model', ->
    reference: @get('model')
    user: @get('currentUser')

  emailForm: Radium.computed.newForm 'email'

  emailFormDefaults: Ember.computed 'model', ->
    to: Ember.A([@get('model')])

  queryParams: ['form']
  form: null
