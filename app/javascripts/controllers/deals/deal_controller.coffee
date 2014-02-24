require 'lib/radium/buffered_proxy'
require 'forms/todo_form'
require 'controllers/deals/checklist_mixin'
require 'mixins/controllers/change_deal_status_mixin'

Radium.DealStatusItemController = Radium.ObjectController.extend
  classStatus: Ember.computed 'model', ->
    @get('model').dasherize()

Radium.DealController = Radium.DealBaseController.extend Radium.ChecklistMixin, BufferedProxy,
  Radium.ChangeDealStatusMixin, Radium.AttachedFilesMixin,

  actions:
    togglePublished: ->
      #FIXME: hack to stop this being bubbled here on error
      return unless Ember.$(event.target).hasClass 'publish'

      status = if @get('isPublic')
                 "unpublished"
               else
                 @get('firstState')

      @set 'model.status', status

      @get('store').commit()

  needs: ['accountSettings', 'users', 'contacts']
  firstState: Ember.computed.alias('controllers.accountSettings.firstState')
  loadedPages: [1]

  contacts: Ember.computed.alias 'controllers.contacts.content'

  dealPercentage:( ->
    status = @get('status')
    return 100 if status == 'closed'
    return 0 if status == 'lost'
    statuses = @get('statuses')
    index = statuses.indexOf(status)
    Math.floor (index / statuses.length) * 100
  ).property('status')

  isPublic: Ember.computed.not 'isUnpublished'
  statusDisabled: Ember.computed.not('isPublic')

  # FIXME: How do we determine this?
  isEditable: true

  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  contact: Ember.computed.alias('model.contact')

  formBox: (->
    Radium.FormBox.create
      compactFormButtons: true
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')
      # discussionForm: @get('discussionForm')
      meetingForm: @get('meetingForm')
  ).property('todoForm', 'callForm', 'discussionForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    description: null
    contact: @get('contact')
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  discussionForm: Radium.computed.newForm('discussion')

  discussionFormDefaults: (->
    reference: @get('model')
    user: @get('currentUser')
    about: @get('model')
  ).property('model')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: ( ->
    topic: null
    location: ""
    isNew: true
    reference: @get('model')
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now').advance(hour: 1)
    endsAt: @get('now').advance(hour: 2)
    invitations: Ember.A()
    reference: @get('model')
  ).property('model', 'now')

  dealProgressClass: (->
    "status-#{@get('status')}"
  ).property('status')
