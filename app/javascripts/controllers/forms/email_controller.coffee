Radium.FormsEmailController = Ember.ObjectController.extend Radium.CurrentUserMixin,  Ember.Evented,
  needs: ['groups','contacts','users','clock']
  now: Ember.computed.alias('clock.now')
  users: Ember.computed.alias 'controllers.users'
  contacts: Ember.computed.alias 'controllers.contacts'

  people: ( ->
    users = @get('users').mapProperty('content')
    contacts = @get('contacts')

    Radium.PeopleList.listPeople(users, contacts)
      .filter (person) -> person.get('email')
  ).property('users.[]', 'contacts.[]')
