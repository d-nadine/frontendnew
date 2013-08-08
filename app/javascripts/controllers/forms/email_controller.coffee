Radium.FormsEmailController = Radium.ObjectController.extend Ember.Evented,
  needs: ['tags','contacts','users','userSettings']
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'
  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
  user: Ember.computed.alias 'controllers.currentUser'
  isEditable: true

  people: ( ->
    users = @get('users').mapProperty('content')
    contacts = @get('contacts')

    Radium.PeopleList.listPeople(users, contacts)
      .filter (person) -> person.get('email') || person.get('primaryEmail.value')
  ).property('users.[]', 'contacts.[]')

  expandList: (section) ->
    @set("show#{section.capitalize()}", true)

  toggleReminderForm: ->
    @toggleProperty 'showCheckForResponse'

  createSignature: ->
    @set 'signatureSubmited', true

    return unless @get('signature.length')

    @set 'signatureSubmited', false

    @get('settings').one 'didUpdate', =>
      @send 'flashSuccess', 'Signature updated'

    @get('store').commit()

    @trigger 'signatureAdded'

  submit: (form) ->
    @send 'sendEmail', form
