Autocomplete =
  lookup: (term) ->
    @contacts().find (contact) ->
      contact.get('name') is term

  contacts: -> Radium.Contact.all()

Radium.FormsTodoController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

  userName: null

  referenceNameDidChange: (->
    content = @get 'content'
    return unless content

    term = @get 'referenceName'

    if term
      result = Autocomplete.lookup term
      @set 'reference', result
    else
      @set 'reference', null
  ).observes('referenceName')

  userNameDidChange: (->
    result = Radium.User.all().find (user) =>
      user.get('name') is @get('userName')

    @set 'user', result if result
  ).observes('userName')

  userDidChange: (->
    @set 'userName', @get('user.name')
  ).observes('user')

  toggleExpanded: -> @toggleProperty 'isExpanded'

