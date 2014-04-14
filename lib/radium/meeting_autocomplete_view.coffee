Radium.MeetingAutocompleteView = Radium.AsyncAutocompleteView.extend
  actions:
    addSelection: (item) ->
      if @get('controller.isNew')
        @get('controller').send('addSelection', item)
      else
        @get('controller').send('addAttendeeToExistingMeeting', item)

    removeSelection: (item) ->
      @get('controller').send('removeSelection', item)

  sourceBinding: 'controller.participants'
  currentUserEmail: Ember.computed.alias 'controller.currentUser.email'
  deleteOnBackSpace: false

  queryParameters: (query) ->
    term: query
    email_only: true
    scopes: ['user', 'contact']

  filterResults: (item) ->
    item.get('email').toLowerCase() != @get('parentView.currentUserEmail').toLowerCase() &&
    !@get('source').map((selection) => selection.get('email')).contains(item.get('email'))
