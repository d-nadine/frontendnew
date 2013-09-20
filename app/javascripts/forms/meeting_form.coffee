require 'forms/form'

Radium.MeetingForm = Radium.Form.extend
  data: ( ->
    topic: @get('topic')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    invitations: Ember.A()
  ).property().volatile()

  reset: ->
    return unless @get('isNew')
    @_super.apply this, arguments
    @get('users').clear()
    @get('contacts').clear()
    @get('invitations').clear()
    @set('submitForm', false)

  commit: ->
    isNew = @get('isNew')

    meeting = if isNew
                Radium.CreateMeeting.createRecord @get('data')
              else
                @get('model')

    users = @get('users').slice()
    contacts = @get('contacts').slice()
    reference = @get('reference')

    if isNew
      @get('users').forEach (user) =>
        meeting.get('invitations').addObject person: type: 'user', id: user.get('id')

      @get('contacts').forEach (contact) =>
        if contact.get('id')
          meeting.get('invitations').addObject person: type: 'contact', id: contact.get('id')
        else
          meeting.get('invitations').addObject email: contact.get('email')

      if @get('reference') && @get('reference.constructor') is Radium.Contact
          meeting.get('invitations').addObject person: type: 'contact', id: @get('reference.id')

    meeting.one 'didCreate', (meeting) =>
      # FIXME: client side hack.  The server should return the meeting
      # with the relationships set
      @get('currentUser.model').reload()

      users.forEach (user) -> user.reload()
      contacts.forEach (contact) -> 
        contact.reload() if contact.reload
      reference.reload() if reference

    @get('store').commit()
