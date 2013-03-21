Radium.FormsEmailController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['groups','contacts','users','clock','settings']
  now: Ember.computed.alias('clock.now')
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'
  signature: Ember.computed.alias 'controllers.settings.signature'

  people: ( ->
    users = @get('users').mapProperty('content')
    contacts = @get('contacts')

    Radium.PeopleList.listPeople(users, contacts)
      .filter (person) -> person.get('email')
  ).property('users.[]', 'contacts.[]')

  expandList: (section) ->
    @set("show#{section.capitalize()}", true)

  expandCheckForResponse: ->
    @toggleProperty 'showCheckForResponse'

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'justAdded', true

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false

      @get('model').commit()
    ), 1200)



