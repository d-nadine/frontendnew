Radium.AssigntoPickerComponent = Ember.Component.extend
  actions:
    assignContact: (contact, user) ->
      contact.set 'user', user

      contact.one 'didUpdate', =>
        @send 'flashSuccess', "#{contact.get('displayName')} has been assigned to #{user.get('displayName')}"

      contact.one 'becameInvalid', =>
        @send 'flashError', contact

      contact.one 'bemameError', =>
        @send 'an error has occurred and the assignment was not completed'

      @get('store').commit()
      false

  classNames: ['btn-group']

  store: Ember.computed ->
    @get('container').lookup('store:main')