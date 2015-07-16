require "mixins/save_contact_actions"
require "mixins/persist_tags_mixin"
require "mixins/controllers/update_contact_poller"
require "mixins/save_contact_actions"
require "mixins/persist_tags_mixin"
require "mixins/controllers/track_contact_mixin"
require "mixins/controllers/attached_files_mixin"

Radium.ContactMainComponent = Ember.Component.extend  Radium.AttachedFilesMixin,
Radium.UpdateContactPoller,
  Radium.TrackContactMixin,
  Radium.SaveContactActions,
  Radium.PersistTagsMixin,
  Radium.SaveEmailMixin,
  Ember.Evented,
  actions:
    removeMultiple: (relationship, item) ->
      @get(relationship).removeObject item

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

  isEditable: true
  loadedPages: [1]

  dealsTotal: Ember.computed 'deals.[]', ->
    @get('deals').reduce((preVal, item) ->
      value = if item.get('status') == 'closed' then item.get('value') else 0

      preVal + value
    , 0, 'value')

  model: Ember.computed.oneWay 'contact'

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      meetingForm: @get('meetingForm')
      emailForm: @get('emailForm')
      about: @get('contact')

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
    to: Ember.A([@get('contact')])

  queryParams: ['form']
  form: null
